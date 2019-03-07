/**
 * Wrapper Class to store the information of a treatment session.
 * @author Hiram Perez
 */
public class TreatmentInformationWrapper_MC {
    public String strStepName {get; set;}
    public ProviderInformationWrapper_MC objSelectedProvider {get; set;}
    public List<ProviderInformationWrapper_MC> lstProviderOptions {get; set;}
    public TreatmentCostDetailsWrapper_MC objCostDetails {get; set;}
}