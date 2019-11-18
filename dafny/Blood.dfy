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
    var use_by: int; // UTC seconds since 1970-01-01 00:00:00 GTM
    var state: int;
    var test_state: int;
    var blood_type: string;

    constructor(add_time:int , use_by:int,state : int , test_state:int , blood_type:string) 
    modifies this;
    {
        this.add_time := add_time;
        this.use_by := use_by;
        this.state := state;
        this.test_state := test_state;
        this.blood_type := blood_type;
    }

    // should be moved to some upper level methods
    method is_expired(curr_time: int) returns (expired: bool)
    // requires curr_time is correct, but we cannot prove this
    ensures expired <==> use_by >= curr_time;
    {
        if curr_time > use_by {
            expired := false;
        }
        else {
            expired := true;
        }
    }

    method blood_test(test_state:int) 
    modifies this;
    {
        this.test_state := test_state;
    }
}




