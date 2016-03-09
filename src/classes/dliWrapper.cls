//TODO: if you see this and you are the author of this class, please include the docummentation and your signature.
public class dliWrapper {
        public Boolean dliSelected {get; set;}
        public QuoteLineitem dli {get; set;}
        public Integer dliIndex {get; set;} //This will serve as a temporary ID for the new line items being created. this will help us create new line items were we can change the product.

        public dliWrapper() {
            dliSelected = false;
            dli = New QuoteLineitem();
        }
    }