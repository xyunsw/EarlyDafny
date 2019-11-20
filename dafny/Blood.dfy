/*
test_state:
1 = not tested (directly comes from Bat-mobile)
2 = Good blood
3 = Bad blood

state:
1 = in inventory
2 = testing (in pathologies)
3 = used (by organization)
4 = disposed (expired blood and disposed by vampire)
*/

class Blood {
    var add_time: int;
    var use_by: int; // UTC seconds since 1970-01-01 00:00:00 GTM, could be negative
    var state: int;
    var test_state: int;
    var blood_type: string;

    // just ensures the state is valid
    predicate valid()
    reads this
    {
        state >= 1 && state <= 4 && test_state >=1 && test_state <= 3
    }

    constructor(){
        // sets the default state
        state := 1;  // in inventory
        test_state := 1;   // not tested
    }    

    method blood_test(test_state:int) 
    requires test_state>=1 && test_state<=3;
    requires valid();
    ensures valid();
    modifies this;
    {
        this.test_state := test_state;
    }
    
    method is_good_blood() returns (result: bool)
    requires valid();
    ensures valid();
    ensures result == (test_state == 2)
    {
        if(test_state == 2){
            result := true;
        } else{
            result := false;
        }
    }
}




