import QtQuick 2.0
import Sailfish.Silica 1.0
import "Persistence.js" as Persistence

Dialog {
	id: page

	property var girlInfo

	DialogHeader {
		id: header
		title: qsTr("New girl")
	}

	SilicaFlickable {
		anchors.top: header.bottom
		anchors.bottom: page.bottom
		anchors.left: page.left
		anchors.right: page.right
		clip: true

		contentHeight: column.height

		Column {
			id: column
			width: page.width

			spacing: Theme.paddingSmall
			TextField {
				id: name
				width: parent.width
				placeholderText: qsTr("Enter girl name")
				label: qsTr("Girl name")
			}
			SectionHeader {
				text: qsTr("Cycle")
			}
			Slider {
				id: cycleLength
				width: parent.width
				label: qsTr("Days")
				minimumValue: 25
				maximumValue: 35
				value: 28
				stepSize: 1
				valueText: value
				onValueChanged: {
					if (value < dayInCycle.value) {
						dayInCycle.value = value
					}
				}

			}
			Slider {
				id: dayInCycle
				width: parent.width
				label: qsTr("Current day")
				minimumValue: 1
				maximumValue: 35
				value: 1
				stepSize: 1
				valueText: value == 1 ? qsTr("Menstruation") : value
				onValueChanged: {
					if (value > cycleLength.value) {
						value = cycleLength.value
					}
				}
			}
			SectionHeader {
				text: qsTr("PMS")
			}
			Slider {
				id: pmsCount
				width: parent.width
				label: qsTr("Days")
				minimumValue: 4
				maximumValue: 11
				value: 7
				stepSize: 1
				valueText: value == 4 ? qsTr("Don't show") : value
			}
		}
		VerticalScrollDecorator {}
	}

	Component.onCompleted: {
		if (girlInfo) {
			header.title = qsTr("Edit girl");

			name.text = girlInfo.name;
			cycleLength.value = girlInfo.cycle;
			dayInCycle.value = girlInfo.dayInCycle;
			pmsCount.value = girlInfo.pms;
		}
	}

	canAccept: String(name.text).trim().length > 0
	onAccepted: {
		var dt;
		if (girlInfo) {
			//console.log(girlInfo);

			var update = false;
			if (girlInfo.name !== String(name.text).trim()) {
				update = true;
				girlInfo.name = String(name.text).trim();
			}
			if (girlInfo.cycle !== cycleLength.value) {
				update = true;
				girlInfo.cycle = cycleLength.value;
			}
			if (girlInfo.dayInCycle !== dayInCycle.value) {
				update = true;
				dt = new Date();
				dt.setUTCHours(0, 0, 0, 0);
				dt.setUTCDate(dt.getUTCDate() - dayInCycle.value + 1)
				girlInfo.day1ms = dt.getTime();
			}
			if (girlInfo.pms !== pmsCount.value) {
				update = true;
				girlInfo.pms = pmsCount.value;
			}
			if (update) {
				Persistence.updateGirl(girlInfo);
			}
		} else {
			dt = new Date();
			dt.setUTCHours(0, 0, 0, 0);
			dt.setUTCDate(dt.getUTCDate() - dayInCycle.value + 1)
			var girl = {
				name: String(name.text).trim(),
				cycle: cycleLength.value,
				day1ms: dt.getTime(),
				pms: pmsCount.value
			};

			var dbid = Persistence.persistGirl(girl);
			console.log(dbid);
			girl['dbid'] = parseInt(dbid);
			girlInfo = girl;
		}
	}
}

