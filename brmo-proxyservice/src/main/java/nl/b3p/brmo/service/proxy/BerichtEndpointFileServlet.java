/*
 * Copyright (C) 2015 B3Partners B.V.
 */
package nl.b3p.brmo.service.proxy;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Endpoint servlet welke geposte bestanden opslaat in een directory conform de
 * configuratie. Voorbeeld:
 * {@code curl -X POST -H "Content-Type: application/xml" http://localhost:8084/brmo-proxyservice/brkbericht -d  @'/testbestanden/BRK_KLEIN_SNAPSHOT.xml'}
 *
 * @author Mark Prins <mark@b3partners.nl>
 */
public class BerichtEndpointFileServlet extends HttpServlet {

    private static final Log log = LogFactory.getLog(BerichtEndpointFileServlet.class);

    private static final String SAVE_DIR = "save_dir";
    private File saveDir;
    private static final String MAX_UPLOAD_SIZE = "max_upload_size";
    private int maxUploadSize;

    @Override
    public void init() throws ServletException {
        String _saveDir = this.getInitParameter(SAVE_DIR);
        if (_saveDir == null && !_saveDir.isEmpty()) {
            throw new ServletException("De parameter '" + SAVE_DIR + "' is benodigd.");
        }
        this.saveDir = new File(_saveDir);
        try {
            FileUtils.forceMkdir(saveDir);
        } catch (IOException ex) {
            throw new ServletException(ex);
        }
        if (!this.saveDir.canWrite()) {
            throw new ServletException("De directory '" + _saveDir + "' is niet schrijfbaar.");
        }
        try {
            this.maxUploadSize = Integer.parseInt(this.getInitParameter(MAX_UPLOAD_SIZE)) * 1024;
        } catch (NumberFormatException nfe) {
            this.maxUploadSize = 25 * 1024 * 1024;
            log.warn("De maximale upload size is ingesteld op 25 MB (default).");
        }
    }

    /**
     * Handles the HTTP {@code POST}.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getContentLength() > this.maxUploadSize) {
            throw new ServletException("De 'max_upload_size' is overschreden.");
        }

        File _tmpfile = new File(FileUtils.getTempDirectory(), this.getFileName());
        FileUtils.copyInputStreamToFile(request.getInputStream(), _tmpfile);
        FileUtils.moveToDirectory(_tmpfile, this.saveDir, true);
        log.info(String.format("Aangeboden bestand '%s' opgeslagen in directory: %s.",
                _tmpfile.getName(), this.saveDir));
        response.setStatus(HttpServletResponse.SC_OK);
    }

    /**
     * "verzint" de bestandsnaam.
     *
     * @return de bestandsnaam {@code post-op-yyyy-MM-dd-HH_mm_ss_SSS.xml}
     */
    private String getFileName() {
        final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH_mm_ss_SSS");
        return "post-op-" + sdf.format(new Date()) + ".xml";
    }
}
