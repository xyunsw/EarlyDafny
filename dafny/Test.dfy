include "Blood.dfy"
include "BloodFilter.dfy"
include "Inventory.dfy"

method Main()
{
    var blood1:Blood := new Blood(-1,0,1,2,"A");
    blood1.blood_test(2);
    var inventory: Inventory := new Inventory();
    inventory.add_blood(blood1);
    var request_blood : seq<Blood> := inventory.request_blood(1,"A","123",0);
}