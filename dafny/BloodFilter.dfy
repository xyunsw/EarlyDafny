/*
I cannot find a type of ordered collection type in dafny that allows dynamically inserting elements (like list in python)
currently I have to use seq to store blood and use add (+) to simulate inserting elements
*/
include "Blood.dfy"


// multiset(a[..]) == multiset(old(a[..])) doesn't work for array<Blood>, probably because of the type of the array
// I have to make this function
function toMultiset(input: array<Blood>): multiset<Blood>
requires input != null;
requires forall i :: 0 <= i < input.Length ==> input[i] != null;
//ensures forall i :: 0 <= i < |res| ==> res[i] != null;
//ensures forall x :: x in res ==> x != null;
reads input
{
    multiset(input[..])
}

predicate sorted_useby(bloods: array<Blood>, low:int, high:int)
requires bloods != null 
requires 0 <= low <= high <= bloods.Length
requires forall i :: low <= i < high ==> bloods[i] != null;
reads bloods
reads set m | 0 <= m < bloods.Length :: bloods[m]
{ 
    forall i,j: int :: low <= i < j < high ==> bloods[i].use_by <= bloods[j].use_by
}


// verifies sort_blood_by_useby_asc(bloods: list) BloodFilter.py
// other "sort_blood_by_*" functions are also implemented using the same algorithm
method sort_blood_by_useby_asc(bloods: array<Blood>)
requires bloods != null;
requires forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
ensures forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
ensures sorted_useby(bloods, 0, bloods.Length);
ensures toMultiset(bloods) == toMultiset(old(bloods));
modifies bloods;
{
    assert forall i :: 0 <= i < old(bloods).Length ==> old(bloods)[i] != null;
    assert toMultiset(bloods) == toMultiset(old(bloods));
    var sorted_tail := 0;

    while (sorted_tail < bloods.Length)
    decreases bloods.Length - sorted_tail;
    invariant 0 <= sorted_tail <= bloods.Length;
    //invariant forall i :: 0 <= i < sorted_tail ==> a[i] != null;
    invariant forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
    invariant toMultiset(bloods) == toMultiset(old(bloods));
    invariant sorted_useby(bloods, 0, sorted_tail);
    {
        var to_swap := sorted_tail;
        while (to_swap >= 1 && bloods[to_swap - 1].use_by > bloods[to_swap].use_by)
        decreases to_swap;
        invariant 0 <= to_swap <= sorted_tail;
        //invariant forall i :: 0 <= i < to_swap ==> a[i] != null;
        //invariant forall i :: to_swap <= i < sorted_tail ==> a[i] != null;
        invariant forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
        invariant toMultiset(bloods) == toMultiset(old(bloods));
        invariant forall i, j :: (0 <= i < j <= sorted_tail && j != to_swap) ==> bloods[i].use_by <= bloods[j].use_by;
        {
            bloods[to_swap - 1], bloods[to_swap] := bloods[to_swap], bloods[to_swap - 1];
            to_swap := to_swap-1;
        }
        assert forall i :: 0 <= i <= sorted_tail ==> bloods[i] != null;
        //assert to_swap == 0 ==> a[to_swap - 1].use_by => a[to_swap].use_by;
        sorted_tail := sorted_tail + 1;
        assert forall i :: 0 <= i < sorted_tail ==> bloods[i] != null;
    }
    assert forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
    assert toMultiset(bloods) == toMultiset(old(bloods));
}


// verifies search_blood_by_id in BloodFilter.py
method search_blood_by_id(bloods: seq<Blood>, id: int) returns(idx: int)
requires forall i :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures forall i :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures idx >= 0 ==> idx < |bloods| && bloods[idx].id == id;
ensures idx == -1 ==> (forall i :: 0 <= i < |bloods| ==> bloods[i].id != id);
{
    idx := 0;

    while idx < |bloods|
    decreases |bloods| - idx;
    invariant 0 <= idx <= |bloods|;
    // invariant found >= 0 ==> (exists i :: 0 <= i < idx && bloods[i].id == id);
    invariant forall i :: 0 <= i < idx ==> bloods[i].id != id;
    {
        if bloods[idx].id == id {
            return;
        }
        idx := idx + 1;
    }
    idx := -1;
}


// verifies filter_not_expired_blood in BloodFilter.py
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


// verifies filter_blood_by_state in BloodFilter.py
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


// verifies filter_blood_by_test_state in BloodFilter.py
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


// verifies filter_blood_by_type in BloodFilter.py
method filter_blood_by_type(bloods: seq<Blood>, blood_type: string) returns (res: seq<Blood>)
requires forall i:int :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures forall i: int :: 0 <= i < |res| ==> res[i] != null;
ensures forall i: int :: 0 <= i < |res| ==> res[i].blood_type == blood_type;
ensures forall i :: 0 <= i < |res| ==> (res[i] in bloods);
{
    res := [];
    var idx: int := 0;
    while idx < |bloods|
    decreases |bloods| - idx;
    invariant forall i: int :: 0 <= i < |res| ==> res[i] != null;
    invariant forall i: int :: 0 <= i < |res| ==> res[i].blood_type == blood_type;
    invariant 0 <= idx <= |bloods|;
    invariant forall i :: 0 <= i < |res| ==> (exists j :: 0 <= j < idx && res[i] == bloods[j]);
    {
        if bloods[idx].blood_type == blood_type {
            res := res + [bloods[idx]];
        }
        idx := idx + 1;
    }
}


// verifies filter_blood_to_send in BloodFilter.py
method filter_blood_to_send(bloods: seq<Blood>, curr_time: int) returns (res3: seq<Blood>)
requires forall i: int :: 0 <= i < |bloods| ==> bloods[i] != null;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i] != null;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i].use_by > curr_time;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i].state == 1;
ensures forall i: int :: 0 <= i < |res3| ==> res3[i].test_state == 2;
ensures forall i :: 0 <= i < |res3| ==> (res3[i] in bloods);
{
    var res := filter_not_expired_blood(bloods, curr_time);
    var res2 := filter_blood_by_state(res, 1);  // 1 for "in inventory", see Blood.dfy
    res3 := filter_blood_by_test_state(res2, 2);    // 2 for good blood, see Blood.dfy
}