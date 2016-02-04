/*
  Copyright (C) 2016 Amilcar Santos
  Contact: Amilcar Santos <amilcar.santos@gmail.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Amilcar Santos nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "controls"
import "Persistence.js" as Persistence
import "Algo.js" as Algo

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
				minimumValue: 21
				maximumValue: 45
				value: 28
				stepSize: 1
				valueText: value
				onValueChanged: {
					if (value < dayInCycle.value) {
						dayInCycle.value = value
					}
				}
			}
			SectionHeader {
				text: qsTr("Current day")
			}
			Slider {
				id: dayInCycle
				width: parent.width
				minimumValue: 1
				maximumValue: 45
				label: qsTr("Day in cycle")
				value: 1
				stepSize: 1
				valueText: {
					if (dateInCycle.selectedDate) {
						return "";
					}
					if (value == 1) {
						return qsTr("Menstruation");
					}
					return value;
				}
				onValueChanged: {
					if (value > cycleLength.value) {
						value = cycleLength.value
					}
				}
			}
			ValueButtonEx {
				id: dateInCycle
				property var selectedDate

				function openDateDialog() {
					var _selectedDate = selectedDate;
					if (!_selectedDate) {
						_selectedDate = new Date(Algo.todayMS());
					}

					var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
						date: _selectedDate
					})
					dialog.accepted.connect(function() {
						value = dialog.dateText
						selectedDate = dialog.date
						dayInCycle.value = 1
						dayInCycle.handleVisible = false
						dayInCycle.enabled = false

					})
				}
				visible: !page.girlInfo
				label: qsTr("Menstruation")
				value: qsTr("Select")
				description: qsTr("By last date")
				width: parent.width
				onClicked: openDateDialog()
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
			if (girlInfo.cycle !== cycleLength.value
					|| girlInfo.dayInCycle !== dayInCycle.value) {
				update = true;
				girlInfo.cycle = cycleLength.value;
				dt = new Date(Algo.todayMS());
				dt.setDate(dt.getDate() - dayInCycle.value + 1)
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
			if (dateInCycle.selectedDate) {
				var sdt = dateInCycle.selectedDate;
				dt = new Date(Date.UTC(sdt.getUTCFullYear(), sdt.getUTCMonth(), sdt.getUTCDate()));
			} else {
				dt = new Date(Algo.todayMS());
				dt.setDate(dt.getDate() - dayInCycle.value + 1);
			}
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

