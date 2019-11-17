/*
I cannot find a type of ordered collection type in dafny that allows dynamic inserting elements (like list in python)
currently I have to use seq to store blood and use add (+) to simulate inserting elements
*/
include "Blood.dfy"

method filter_not_expired_blood(bloods: seq<Blood>, curr_time: int) returns(res: seq<Blood>)
// requires curr_time is correct
requires forall i: int :: 0 <= i < |bloods| ==> bloods[i] != null;   // for dafny 1.9.7 compatible
ensures forall i: int :: 0 <= i < |res| ==> res[i] != null;          // for dafny 1.9.7 compatible
ensures forall i: int :: 0 <= i < |res| ==> res[i].use_by > curr_time;
// ensures forall i :: 0 <= i < |res| ==> (exists j :: 0 <= j < |bloods| && res[i] == bloods[j]); 
ensures forall i :: 0 <= i < |res| ==> (res[i] in bloods);
{
    res := [];
    // any battery to iterate a sequence?
    var idx: int := 0;
    while idx < |bloods|
    decreases |bloods| - idx;
    invariant 0 <= idx <= |bloods|;
    invariant forall i: int :: 0 <= i < |res| ==> res[i] != null;
    invariant forall i :: 0 <= i < |res| ==> (exists j :: 0 <= j < idx && res[i] == bloods[j]);
    invariant forall i: int :: 0 <= i < |res| ==> res[i].use_by > curr_time;
    {
        if bloods[idx].use_by > curr_time {
            res := res + [bloods[idx]];
        }
        idx := idx + 1;
        //assert forall i :: 0 <= i < |res| ==> (exists j :: 0 <= j < idx && res[i] == bloods[j]);
    }
    assert idx == |bloods|;
    assert forall i :: 0 <= i < |res| ==> (res[i] in bloods);
    assert forall i: int :: 0 <= i < |res| ==> res[i] != null;
}

method filter_blood_by_state(bloods: seq<Blood>, blood_state: int) returns (res: seq<Blood>)
requires forall i: int :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures forall i: int :: 0 <= i < |res| ==> res[i] != null;
ensures forall i: int :: 0 <= i < |res| ==> res[i].state == blood_state;
ensures forall i :: 0 <= i < |res| ==> (res[i] in bloods);
{
    res := [];
    var idx: int := 0;
    while idx < |bloods|
    decreases |bloods| - idx;
    invariant forall i: int :: 0 <= i < |res| ==> res[i] != null;
    invariant forall i: int :: 0 <= i < |res| ==> res[i].state == blood_state;
    invariant 0 <= idx <= |bloods|;
    invariant forall i :: 0 <= i < |res| ==> (exists j :: 0 <= j < idx && res[i] == bloods[j]);
    {
        if bloods[idx].state == blood_state {
            res := res + [bloods[idx]];
        }
        idx := idx + 1;
    }
}

method filter_blood_by_test_state(bloods: seq<Blood>, blood_test_state: int) returns (res: seq<Blood>)
requires forall i: int :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures forall i: int :: 0 <= i < |res| ==> res[i] != null;
ensures forall i: int :: 0 <= i < |res| ==> res[i].test_state == blood_test_state;
ensures forall i :: 0 <= i < |res| ==> (res[i] in bloods);
{
    res := [];
    var idx: int := 0;
    while idx < |bloods|
    decreases |bloods| - idx;
    invariant forall i: int :: 0 <= i < |res| ==> res[i] != null;
    invariant forall i: int :: 0 <= i < |res| ==> res[i].test_state == blood_test_state;
    invariant 0 <= idx <= |bloods|;
    invariant forall i :: 0 <= i < |res| ==> (exists j :: 0 <= j < idx && res[i] == bloods[j]);
    {
        if bloods[idx].test_state == blood_test_state {
            res := res + [bloods[idx]];
        }
        idx := idx + 1;
    }
}

/*
method filter_blood_by_type(bloods: seq<Blood>, blood_type: string) returns (res: seq<Blood>)
ensures forall i: int :: 0 <= i < |res| ==> res[i].blood_type == blood_type;
{
    res := [];
    var idx: int := 0;
    while idx < |bloods|
    decreases |bloods| - idx;
    invariant forall i: int :: 0 <= i < |res| ==> res[i].blood_type == blood_type;
    {
        if bloods[idx].blood_type == blood_type {
            res := res + [bloods[idx]];
        }
        idx := idx + 1;
    }
}
*/

method filter_blood_to_send(bloods: seq<Blood>, curr_time: int) returns (res3: seq<Blood>)
requires forall i: int :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i] != null;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i].use_by > curr_time;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i].state == 1;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i].test_state == 2;
{
    var res := filter_not_expired_blood(bloods, curr_time);
    // assert forall i: int :: 0 <= i < |res| ==> res[i].use_by > curr_time;
    // assert forall i :: 0 <= i < |res| ==> (res[i] in bloods);
    var res2 := filter_blood_by_state(res, 1);  // 1 for "in inventory", see Blood.dfy
    // assert forall i :: 0 <= i < |res2| ==> (res2[i] in res);
    // assert forall i: int :: 0 <= i < |res2| ==> res2[i].state == 1;
    // assert forall i: int :: 0 <= i < |res| ==> res[i].use_by > curr_time;
    res3 := filter_blood_by_test_state(res2, 2);    // 2 for good blood, see Blood.dfy
}


