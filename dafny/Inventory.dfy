include "Blood.dfy"
include "BloodFilter.dfy"


class Inventory {
    var bloods: seq<Blood>;

    predicate Valid()
    reads this;
    {
        forall i: int :: 0 <= i < |bloods| ==> bloods[i] != null
    }
    constructor() 
    ensures Valid();
    modifies this;
    {
        bloods := [];
    }

    method add_blood(blood : Blood)
    requires Valid();
    requires blood != null;
    ensures Valid();
    modifies this;
    {
        bloods := bloods + [blood];
    }

    method request_blood(n_bags: int, blood_type: string, curr_time:int) returns (blood_to_send: seq<Blood>)
    requires n_bags > 0;
    requires Valid();
    modifies bloods;
    ensures Valid();
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i] != null;                 //make 1.9.7 complier compatible
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].use_by > curr_time;      
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].state == 3;   // used
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].test_state == 2;   // good blood
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].blood_type == blood_type;
    ensures |blood_to_send| == n_bags || |blood_to_send| == 0;
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i] in bloods;
    {
        blood_to_send := filter_blood_to_send(bloods, curr_time);
        blood_to_send := filter_blood_by_type(blood_to_send, blood_type);
        assert forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].state == 1;   // make sure blood is in inventory
        assert forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].test_state == 2;
        mark_bloods(blood_to_send, 3);  // mark as used
        if n_bags > |blood_to_send| {
            blood_to_send := [];
        }
        else {
            blood_to_send := blood_to_send[0..n_bags];
        }
    }
    
    method mark_bloods(pend_bloods: seq<Blood>, state: int)
    requires forall i: int :: 0 <= i < |pend_bloods| ==> pend_bloods[i] != null
    requires state == 1 || state == 2 || state == 3 || state == 4
    requires Valid();
    ensures Valid();
    ensures forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].state == state;
    ensures forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].test_state == old(pend_bloods[i].test_state);
    ensures forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].use_by == old(pend_bloods[i].use_by);
    ensures forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].blood_type == old(pend_bloods[i].blood_type);
    ensures multiset(pend_bloods) == multiset(old(pend_bloods));
    modifies pend_bloods;
    {
        var idx := 0;
        while(idx < |pend_bloods|)
        decreases |pend_bloods| - idx;
        invariant idx <= |pend_bloods|;
        invariant forall i :: 0 <= i < idx ==> pend_bloods[i] .state == state;
        invariant forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].test_state == old(pend_bloods[i].test_state);
        invariant forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].use_by == old(pend_bloods[i].use_by);
        invariant forall i :: 0 <= i < |pend_bloods| ==> pend_bloods[i].blood_type == old(pend_bloods[i].blood_type);
        {
            pend_bloods[idx].state := state;
            idx := idx + 1;
        }
        assert forall i: int :: 0 <= i < |pend_bloods| ==> pend_bloods[i].state == state;
    }
}


