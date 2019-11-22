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
{
    array_bloods := new Blood[|Seq_bloods|];
    var i := 0;
    while (i < |Seq_bloods|){
        array_bloods[i] := Seq_bloods[i];
    }
}

method Test(){
    var blood0 := new Blood(0,0);
    assert blood0.use_by == 0 && blood0.state == 1 && blood0.test_state == 1 && blood0.id == 0;
    
    var blood1 := new Blood(1,1);
    assert blood1.use_by == 1 && blood1.state == 1 && blood1.test_state == 1 && blood1.id == 1;

    var Inventory := new Inventory();
    Inventory.add_blood(blood0);
    Inventory.add_blood(blood1);


    //test sort_blood_by_useby_asc
    //change the type seq to array
    var array_bloods := changeType(Inventory.bloods);
    sort_blood_by_useby_asc(array_bloods);
    assert forall i,j :: 0 <= i < j < array_bloods.Length ==> array_bloods[i].use_by <= array_bloods[j].use_by;

    
}