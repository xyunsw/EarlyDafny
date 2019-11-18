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

    constructor() {

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
}

method blood_test() {
    var blood: Blood := new Blood();
}

