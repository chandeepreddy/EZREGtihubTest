public class componentController {
    public String selectedValue {
        get;
        set {
            editMode = (value != null);
            // Side effect here - don't do this!
            selectedValue = value;
        }
    }
    public Boolean editMode {get; private set;}
}