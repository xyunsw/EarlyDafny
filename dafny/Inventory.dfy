include "Blood.dfy"
include "BloodFilter.dfy"

class Inventory {
    var bloods: seq<Blood>;

    constructor() 
    modifies this;
    {
        bloods := [];
    }

    method request_blood(n_bag : int,blood_type : string, org : string, curr_time:int) returns ( blood_to_send: seq<Blood>)
    requires n_bag > 0;
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i] != null;                 //make 1.9.7 complier compatible
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].use_by > curr_time;      
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].state == 1;
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].test_state == 2;
    ensures forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].blood_type == blood_type;
    {
        blood_to_send:=[];
        var idx:= 0;
        while (idx < |bloods|)
        decreases |bloods| - idx;
        invariant forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i] != null;
        invariant forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].use_by > curr_time;
        invariant forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].state == 1;
        invariant forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].test_state == 2
        invariant forall i: int :: 0 <= i < |blood_to_send| ==> blood_to_send[i].blood_type == blood_type;
        {
            if (bloods[idx] != null && bloods[idx].blood_type == blood_type
            && bloods[idx].state == 1 && bloods[idx].test_state == 2
            && bloods[idx].use_by > curr_time){
                blood_to_send := blood_to_send + [bloods[idx]];
            }
            idx := idx + 1;
        }
    }
}

