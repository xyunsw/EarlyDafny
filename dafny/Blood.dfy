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
    var id: int;
    predicate valid()
    reads this
    {
        add_time >= 0 && use_by >= 0 && state >= 1 && state <= 4
    &&  test_state >=1 && test_state <= 3 && blood_type != ""
    }

    constructor(){

    }    

    // constructor(add_time:int , use_by:int,state : int , test_state:int , blood_type:string) 
    // modifies this;
    // {
    //     this.add_time := add_time;
    //     this.use_by := use_by;
    //     this.state := state;
    //     this.test_state := test_state;
    //     this.blood_type := blood_type;
    // }

    // should be moved to some upper level methods
    method is_expired(curr_time: int) returns (expired: bool)
    // requires curr_time is correct, but we cannot prove this
    requires valid();
    ensures valid();
    ensures expired <==> use_by >= curr_time;
    {
        if (curr_time > use_by){
            expired := false;
        }
        else {
            expired := true;
        }
    }

    method blood_test(test_state:int) 
    requires test_state>=1 && test_state<=3;
    requires valid();
    ensures valid();
    modifies this;
    {
        this.test_state := test_state;
    }
    
    method is_good_blood() returns (result: bool)
    requires valid();
    ensures valid();
    ensures result == (test_state == 2)
    {
        if(test_state == 2){
            result := true;
        } else{
            result := false;
        }
    }
    method search_blood_by_id(a:array<Blood>,key:int) returns(res:int)
    ensures res!=-1 ==> (0<=res<a.Length && a[res].id==key)
    ensures res==-1 ==> forall k:: 0<=k<a.Length ==> a[k].id!=key
    {
        res:=0;
        while res<a.Length
        invariant 0<=res<=a.Length
        invariant forall k:: 0<=k<res ==> a[k].id!=key
        decreases a.Length-res
        {
            if(a[res].id==key){
                return res;
            }
            res:=res+1;
        }
        res:=-1;
        
    }
}



