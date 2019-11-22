include "Blood.dfy"
include "BloodFilter.dfy"
include "Inventory.dfy"

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

method changeType(Seq_bloods:seq<Blood>) returns (array_bloods:array<Blood>)
requires forall i :: 0 <= i < |Seq_bloods| ==> Seq_bloods[i] != null;
ensures fresh (array_bloods);
ensures forall i :: 0 <= i < array_bloods.Length ==> array_bloods[i] != null;
{
    var length := |Seq_bloods|;
    array_bloods := new Blood[length];
    var i := 0;
    while (i < length)
    decreases |Seq_bloods| - i;
    invariant 0 <= i <= array_bloods.Length;
    invariant forall j :: 0 <= j < i ==> array_bloods[j] != null;
    {
        array_bloods[i] := Seq_bloods[i];
        i := i + 1;
    }
}

method Test(){
    var blood0 := new Blood(0);
    blood0.use_by := 0;
    assert blood0.use_by == 0 && blood0.state == 1 && blood0.test_state == 1 && blood0.id == 0;
    
    var blood1 := new Blood(1);
    blood1.use_by := 1;
    assert blood1.use_by == 1 && blood1.state == 1 && blood1.test_state == 1 && blood1.id == 1;

    var Inventory := new Inventory();
    Inventory.add_blood(blood0);
    Inventory.add_blood(blood1);


    //test sort_blood_by_useby_asc
    //change the type seq to array
    var array_bloods := changeType(Inventory.bloods);
    sort_blood_by_useby_asc(array_bloods);
    assert forall i,j :: 0 <= i < j < array_bloods.Length ==> array_bloods[i].use_by <= array_bloods[j].use_by;

    //test search_blood_by_id
    var idx := search_blood_by_id(Inventory.bloods,1);
    assert idx >= 0 ==> idx < |Inventory.bloods| && Inventory.bloods[idx].id == 1;
    assert idx == -1 ==> (forall i :: 0 <= i < |Inventory.bloods| ==> Inventory.bloods[i].id != 1);

    idx := search_blood_by_id(Inventory.bloods,100);
    assert idx >= 0 ==> idx < |Inventory.bloods| && Inventory.bloods[idx].id == 100;
    assert idx == -1 ==> (forall i :: 0 <= i < |Inventory.bloods| ==> Inventory.bloods[i].id != 100);

    //test filter_not_expired_blood
    var seq_bloods := filter_not_expired_blood(Inventory.bloods,12);
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].use_by > 12;

    //test filter_blood_by_state
    seq_bloods := filter_blood_by_state(Inventory.bloods,1);
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].state == 1;

    //test filter_blood_by_test_state
    seq_bloods := filter_blood_by_test_state(Inventory.bloods,2);
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].test_state == 2;

    //test filter_blood_by_type
    blood0.blood_type := "A";
    blood1.blood_type := "B";
    seq_bloods := filter_blood_by_type(Inventory.bloods,"A");
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].blood_type == "A";

    //test filter_blood_to_send
    seq_bloods := filter_blood_to_send(Inventory.bloods, 0);
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].use_by > 0;
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].state == 1;
    assert forall i: int :: 0 <= i < |seq_bloods| ==> seq_bloods[i].test_state == 2;
}