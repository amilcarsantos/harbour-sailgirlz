.pragma library

.import Sailfish.Silica 1.0 as Sl

var MN_DAYS = 5;

var PMS_OFF = 4;

var OV_DAYS = 7;
var OV_DAYS_SPAN = 4;
var OV_DAYS_BEFORE = 14;

function daysInCycle(cycle, day1ms, curDay) {
	if (curDay === undefined) {
		curDay = new Date();
		curDay.setUTCHours(0, 0, 0, 0);
	}
	var d = (curDay.getTime() - day1ms) / 86400000 % cycle | 0;
	if (d < 0) {
		d = cycle + d
	}
	return d;
}

function nextOvDays(daysInCycle, cycle) {
	var ds = cycle - OV_DAYS_BEFORE - 2;
	var de = cycle - OV_DAYS_BEFORE;
	if (daysInCycle < ds) {
		return ds - daysInCycle;
	}
	if (daysInCycle > de) {
		return cycle + ds - daysInCycle;
	}
	return 0; // make 3 days has 'today'
}


function nextMnDays(daysInCycle, cycle) {
	if (daysInCycle === 0) {
		return 0;
	}
	return cycle - daysInCycle;
}



function formatDays(d) {
	if (d === 0) {
		return qsTr("today");
	}
	if (d === 1) {
		return qsTr("tomorrow");
	}
	var dt = new Date();
	dt.setDate(dt.getDate() + d);
	return Sl.Format.formatDate(dt, Sl.Formatter.DurationElapsed);
}
