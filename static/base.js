function utcToDateString(utc) {
    let d = new Date(utc * 1000);
    let date = d.toDateString();
    let time = d.toTimeString();
    date = date.replace(/^\S+ /, "");
    time = time.split(' ')[0];
    return date + " " + time;
}

