/**
 * Wrapper Class for the total cost ammounts of a treatment infomration.
 * @author Hiram Perez
 */
public class TreatmentCostDetailsWrapper_MC {
    public Integer intEstimatedPocketCost {get; set;}
    public Integer intDeductible {get; set;}
    public Integer intCoinsurance {get; set;}
    public Integer intCopay {get; set;}
    public Integer intPlanCovered {get; set;}
    public Integer intEstimatedTotalCost {get; set;}
    public String strAverageStatus {get; set;}
}