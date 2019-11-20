function utcToDateString(utc) {
    let d = new Date(utc * 1000);
    let date = d.toDateString();
    let time = d.toTimeString();
    date = date.replace(/^\S+ /, "");
    time = time.split(' ')[0];
    return date + " " + time;
}


function immutubleElemTimeTransfer(elem, field) {
    let time = elem[field];
    time = parseInt(time);
    if (time !== NaN) {
        elem[field] = utcToDateString(time);
    }
}

function mutubleElemTimeTransfer(elem, field) {
    let visible = elem.cloneNode(false);
    elem.style.display = "none";
    //elem.disabled = true;
    if (elem[field] === "") {
        elem[field] = '0';
    }
    let v_id = elem.id
    if (v_id !== "") {
        visible.id = "";
    }
    visible.name = "";
    elem.parentNode.insertBefore(visible, elem.nextSibling);
    visible[field] = utcToDateString(parseInt(elem[field]));
    visible.addEventListener("change", (event) => {
        let date = new Date(visible[field]);
        let new_utc = date.getTime() / 1000;
        console.log(new_utc);
        if (!isNaN(new_utc)) {
            console.log(new_utc);
            elem[field] = new_utc;
        }
        else {
            //event.preventDefault();
        }
        visible[field] = utcToDateString(parseInt(elem[field]));
    });
}

let state_table = {
    "1": "in inventory",
    "2": "testing",
    "3": "used",
    "4": "disposed"
}
let test_state_table = {
    "1": "not tested",
    "2": "Good blood",
    "3": "Bad blood"
}



