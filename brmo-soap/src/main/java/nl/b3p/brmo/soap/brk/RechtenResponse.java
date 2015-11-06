package nl.b3p.brmo.soap.brk;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import javax.xml.bind.annotation.XmlElement;
import nl.b3p.brmo.soap.db.BrkInfo;

/**
 *
 * @author Chris
 */
public class RechtenResponse {

    private List<ZakelijkRechtResponse> zakelijkRecht = null;

    /**
     * @return the zakelijkRecht
     */
    @XmlElement
    public List<ZakelijkRechtResponse> getZakelijkRecht() {
        return zakelijkRecht;
    }

    /**
     * @param zakelijkRecht the zakelijkRecht to set
     */
    public void setZakelijkRecht(List<ZakelijkRechtResponse> zakelijkRecht) {
        this.zakelijkRecht = zakelijkRecht;
    }
    
    private static StringBuilder createFullColumnsSQL() {
        StringBuilder sql = new StringBuilder();
        sql.append("    zak_recht.indic_betrokken_in_splitsing,");
        sql.append("    zak_recht.ar_noemer,");
        sql.append("    zak_recht.ar_teller,");
        sql.append("    zak_recht.fk_3avr_aand,");
        sql.append("    zak_recht.fk_8pes_sc_identif");
        return sql;
    }

    private static StringBuilder createFromSQL() {
        StringBuilder sql = new StringBuilder();
        sql.append("    zak_recht ");
        return sql;
    }
    
     private static StringBuilder createWhereSQL() {
        StringBuilder sql = new StringBuilder();
        sql.append("    zak_recht.fk_7koz_kad_identif = ? ");
        return sql;
     }
   
    public static RechtenResponse getRechtenByKoz(Long kozId, 
            Map<String, Object> searchContext) throws Exception {
        
        DataSource ds = BrkInfo.getDataSourceRsgb();
        Connection connRsgb = ds.getConnection();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append(createFullColumnsSQL());
        sql.append("FROM ");
        sql.append(createFromSQL());
        sql.append("WHERE ");
        sql.append(createWhereSQL());

        PreparedStatement stm = connRsgb.prepareStatement(sql.toString());
        stm.setObject(1, kozId);
        ResultSet rs = stm.executeQuery();

        RechtenResponse rr = null;
        List<ZakelijkRechtResponse> zrl = null;
        ZakelijkRechtResponse zkRecht = null;
        while (rs.next()) {
            if (rr==null) {
                rr = new RechtenResponse();
                zrl = new ArrayList<ZakelijkRechtResponse>();
                rr.setZakelijkRecht(zrl);
            }
            zkRecht = new ZakelijkRechtResponse();
            
            zkRecht.setAardVerkregenRecht(rs.getString("fk_3avr_aand"));
            zkRecht.setIndicatieBetrokkenInSplitsing(
                    rs.getString("indic_betrokken_in_splitsing")
                            .equalsIgnoreCase("nee")?false:true);
            zkRecht.setNoemer(rs.getInt("ar_noemer"));
            zkRecht.setTeller(rs.getInt("ar_teller"));
            
            Boolean st = (Boolean) searchContext.get(BrkInfo.SUBJECTSTOEVOEGEN);
            if (st != null && st) {
                String pid = rs.getString("fk_8pes_sc_identif");
                NatuurlijkPersoonResponse np
                        = NatuurlijkPersoonResponse.getRecordById(pid, searchContext);
                zkRecht.setNatuurlijkPersoon(np);
                if (np == null) {
                    NietNatuurlijkPersoonResponse nnp
                            = NietNatuurlijkPersoonResponse.getRecordById(pid, searchContext);
                    zkRecht.setNietNatuurlijkPersoon(nnp);
                }
            }
            zrl.add(zkRecht);

        }
        rs.close();
       
        return rr;
    }


}
