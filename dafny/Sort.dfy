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

/*
method seq_to_array(bloods: seq<Blood>) returns (res: array<Blood>)
requires forall i :: 0 <= i < |bloods| ==> bloods[i] != null;
//ensures forall i :: 0 <= i < res.Length ==> res[i] != null;
{
    //res := new Blood[|bloods|] (i requires 0 <= i < |bloods| => (bloods[i]));
    //res := new Blood[|bloods|];
}
*/

predicate sorted_useby(bloods: array<Blood>, low:int, high:int)
requires bloods != null 
requires 0 <= low <= high <= bloods.Length
requires forall i :: low <= i < high ==> bloods[i] != null;
reads bloods
reads set m | 0 <= m < bloods.Length :: bloods[m]
{ 
    forall i,j: int :: low <= i < j < high ==> bloods[i].use_by <= bloods[j].use_by
}


// verifies BloodFilter.py::sort_blood_by_useby_asc(bloods: list)
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

method Main() {
    // this shows dafny has reference semantics
    // var b := new Blood();
    // b.blood_type := "AB";
    // var c := b;
    // c.blood_type := "A";
    // assert b == c;
    // print b.blood_type, " ", c.blood_type, "\n";
    // var b := new Blood(1,1,1,1,"");
    // var a := new int[3];
    // var b := new int[2];
    // a := a + b;
    //var c: array<Blood> := new Blood[1];
    //c[0] := b;
    //var m: multiset<Blood> := multiset(c[..]);

}

