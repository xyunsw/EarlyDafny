include "Blood.dfy"


// use by
predicate is_sorted(bloods: seq<Blood>, ascdesc: bool)
requires forall i :: 0 <= i < |bloods| ==> bloods[i] != null;
reads bloods;
{
    (ascdesc ==> (forall i, j: int :: 0 <= i < j < |bloods| ==> bloods[i].use_by <= bloods[j].use_by)) &&
    (!ascdesc ==> (forall i, j: int :: 0 <= i < j < |bloods| ==> bloods[i].use_by >= bloods[j].use_by))
}

// multiset(a[..]) == multiset(old(a[..])) doesn't work, probably because of the type of the array
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


predicate Sorted(a: array<Blood>, low:int, high:int)
requires a != null // 1.9.7
requires 0<=low<=high<=a.Length
//requires forall i :: low <= i < high ==> a[i] != null;
reads a
reads set m | 0 <= m < a.Length :: a[m]
{ 
    //forall i :: low <= i < high ==> a[i] != null && (forall j,k:: low<=j<k<high ==> a[j].use_by <= a[k].use_by)
    true
}



method InsertionSortSwap(bloods: array<Blood>)
requires bloods != null // 1.9.7
requires forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
ensures Sorted(bloods, 0, bloods.Length);
ensures forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
ensures toMultiset(bloods) == toMultiset(old(bloods));
modifies bloods;
{
    assert forall i :: 0 <= i < old(bloods).Length ==> old(bloods)[i] != null;
    assert toMultiset(bloods) == toMultiset(old(bloods));
    var sorted_tail:=0;
    while (sorted_tail < bloods.Length)
    invariant 0 <= sorted_tail <= bloods.Length;
    //invariant forall i :: 0 <= i < sorted_tail ==> a[i] != null;
    invariant forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
    invariant toMultiset(bloods) == toMultiset(old(bloods));
    invariant Sorted(bloods, 0, sorted_tail);
    {
        var down := sorted_tail; // the next unsorted element
        while (down >= 1 && bloods[down - 1].use_by > bloods[down].use_by)
        invariant 0 <= down <= sorted_tail;
        //invariant forall i :: 0 <= i < down ==> a[i] != null;
        //invariant forall i :: down <= i < sorted_tail ==> a[i] != null;
        invariant forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
        invariant toMultiset(bloods) == toMultiset(old(bloods));
        //invariant forall i,j:: (0<=i<j<=sorted_tail && j!=down) ==> a[i].use_by <= a[j].use_by;
        {
            bloods[down - 1], bloods[down] := bloods[down], bloods[down - 1];
            down := down-1;
        }
        assert forall i :: 0 <= i <= sorted_tail ==> bloods[i] != null;
        //assert down == 0 ==> a[down - 1].use_by => a[down].use_by;
        sorted_tail := sorted_tail + 1;
        assert forall i :: 0 <= i < sorted_tail ==> bloods[i] != null;
    }
    assert forall i :: 0 <= i < bloods.Length ==> bloods[i] != null;
    assert toMultiset(bloods) == toMultiset(old(bloods));
}




/*
predicate Sorted1(a: array<Blood>, low:int, high:int)
requires 0<=low<=high<=a.Length
//requires forall i :: low <= i < high ==> a[i] != null;
reads a
reads set m | 0 <= m < a.Length :: a[m]
{ 
    forall j,k:: low<=j<k<high ==> a[j].use_by <= a[k].use_by
    //true
}



method InsertionSortSwap1(a: array<Blood>)
//requires a.Length > 1
// requires forall i :: 0 <= i < a.Length ==> a[i] != null;
ensures Sorted1(a, 0, a.Length);
ensures toMultiset(a[..]) == toMultiset(old(a[..]));
modifies a;
{
    var sorted_tail := 0;
    while (sorted_tail < a.Length)
    decreases a.Length - sorted_tail;
    invariant 0 <= sorted_tail <= a.Length;
    invariant toMultiset(a[..]) == toMultiset(old(a[..]));
    invariant Sorted1(a, 0, sorted_tail);
    {
        var down := sorted_tail; // the next unordered element
        while (down >= 1 && a[down-1].use_by > a[down].use_by)
        decreases down;
        invariant 0 <= down <= sorted_tail;
        invariant toMultiset(a[..]) == toMultiset(old(a[..]));
        // invariant forall i :: down <= i < sorted_tail ==> a[i] != null;
        invariant forall i,j:: (0<=i<j<=sorted_tail && j!=down) ==> a[i].use_by <= a[j].use_by;
        {
            a[down-1], a[down] := a[down], a[down-1];
            down:=down-1;
        }
        //assert down == 0 ==> a[down] != null;
        sorted_tail := sorted_tail + 1;
    }
}


*/



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

