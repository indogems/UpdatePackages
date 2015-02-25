/*+***********************************************************************************************************************************
 * The contents of this file are subject to the YetiForce Public License Version 1.1 (the "License"); you may not use this file except
 * in compliance with the License.
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
 * See the License for the specific language governing rights and limitations under the License.
 * The Original Code is YetiForce.
 * The Initial Developer of the Original Code is YetiForce. Portions created by YetiForce are Copyright (C) www.yetiforce.com. 
 * All Rights Reserved.
 *************************************************************************************************************************************/
jQuery.Class("OSSTimeControl_Calendar_Js",{
	registerUserListWidget : function(){
		var thisInstance = new OSSTimeControl_Calendar_Js();
		jQuery('#OSSTimeControl_sideBar_LBL_USERS').css('overflow','visible');
		
		app.changeSelectElementView(jQuery('#OSSTimeControl_sideBar_LBL_USERS'));
		//this.registerUserColor();
		$(".calendarUserList .refreshCalendar").click(function () {
			thisInstance.loadCalendarData();
		});
	},
	registerUserColor : function(){
		
	},
},{
	calendarView : false,
	calendarCreateView : false,
	registerCalendar: function () {
		var thisInstance = this;
		var weekDaysArray = {Sunday: 0, Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday: 5, Saturday: 6};
		//User preferred default view
		var userDefaultActivityView = jQuery('#activity_view').val();
		if (userDefaultActivityView == 'Today') {
			userDefaultActivityView = 'agendaDay';
		} else if (userDefaultActivityView == 'This Week') {
			userDefaultActivityView = 'agendaWeek';
		} else {
			userDefaultActivityView = 'month';
		}

		//Default time format
		var userDefaultTimeFormat = jQuery('#time_format').val();
		if (userDefaultTimeFormat == 24) {
			userDefaultTimeFormat = 'H(:mm)';
		} else {
			userDefaultTimeFormat = 'h(:mm)tt';
		}

		//Default first day of the week
		var defaultFirstDay = jQuery('#start_day').val();
		var convertedFirstDay = weekDaysArray[defaultFirstDay];

		//Default first hour of the day
		var defaultFirstHour = jQuery('#start_hour').val();
		var explodedTime = defaultFirstHour.split(':');
		defaultFirstHour = explodedTime['0'];

		//Date format in agenda view must respect user preference
		var dateFormat = jQuery('#date_format').val();
		//Converting to fullcalendar accepting date format
		thisInstance.getCalendarView().fullCalendar({
			header: {
				left: 'month,agendaWeek,agendaDay',
				center: 'title today',
				right: 'prev,next'
			},

			timeFormat: userDefaultTimeFormat,
			axisFormat: userDefaultTimeFormat,
			firstHour: defaultFirstHour,
			firstDay: convertedFirstDay,
			defaultView: userDefaultActivityView,
			editable: true,
			slotMinutes: 15,
			defaultEventMinutes: 0,
			eventLimit: true,
			selectable: true,
			selectHelper: true,
			select: function(start, end) {
				thisInstance.selectDays(start.format(),end.format());
				this.getCalendarView().fullCalendar('unselect');
			},
			eventDrop: function ( event, delta, revertFunc) {
				thisInstance.updateEvent(event, delta, revertFunc);
			},
			eventResize: function (event, delta, revertFunc) {
				thisInstance.updateEvent(event, delta, revertFunc);
			},
			monthNames: [app.vtranslate('JS_JANUARY'), app.vtranslate('JS_FEBRUARY'), app.vtranslate('JS_MARCH'),
				app.vtranslate('JS_APRIL'), app.vtranslate('JS_MAY'), app.vtranslate('JS_JUNE'), app.vtranslate('JS_JULY'),
				app.vtranslate('JS_AUGUST'), app.vtranslate('JS_SEPTEMBER'), app.vtranslate('JS_OCTOBER'),
				app.vtranslate('JS_NOVEMBER'), app.vtranslate('JS_DECEMBER')],
			monthNamesShort: [app.vtranslate('JS_JAN'), app.vtranslate('JS_FEB'), app.vtranslate('JS_MAR'),
				app.vtranslate('JS_APR'), app.vtranslate('JS_MAY'), app.vtranslate('JS_JUN'), app.vtranslate('JS_JUL'),
				app.vtranslate('JS_AUG'), app.vtranslate('JS_SEP'), app.vtranslate('JS_OCT'), app.vtranslate('JS_NOV'),
				app.vtranslate('JS_DEC')],
			dayNames: [app.vtranslate('JS_SUNDAY'), app.vtranslate('JS_MONDAY'), app.vtranslate('JS_TUESDAY'),
				app.vtranslate('JS_WEDNESDAY'), app.vtranslate('JS_THURSDAY'), app.vtranslate('JS_FRIDAY'),
				app.vtranslate('JS_SATURDAY')],
			dayNamesShort: [app.vtranslate('JS_SUN'), app.vtranslate('JS_MON'), app.vtranslate('JS_TUE'),
				app.vtranslate('JS_WED'), app.vtranslate('JS_THU'), app.vtranslate('JS_FRI'),
				app.vtranslate('JS_SAT')],
			buttonText: {
				today: app.vtranslate('JS_TODAY'),
				month: app.vtranslate('JS_MONTH'),
				week: app.vtranslate('JS_WEEK'),
				day: app.vtranslate('JS_DAY')
			},
			allDayText: app.vtranslate('JS_ALL_DAY'),
			eventLimitText: app.vtranslate('JS_MORE')
		});
    },
	loadCalendarData : function(allEvents) {
		var progressInstance = jQuery.progressIndicator();
		var thisInstance = this;
		thisInstance.getCalendarView().fullCalendar('removeEvents');
		var view = thisInstance.getCalendarView().fullCalendar('getView');
		var start_date = view.start.format();
		var end_date  = view.end.format();
		var user = '';
		if(jQuery('#calendarUserList').length == 0){
			user = jQuery('#current_user_id').val();
		}else{
			user = jQuery('#calendarUserList').val();
		}
		if (jQuery('#timecontrolTypes').length > 0) {
			var types = jQuery('#timecontrolTypes').val();	
		}
		if(allEvents == true || types != null){
			var params = {
				module: 'OSSTimeControl',
				action: 'Calendar',
				mode: 'getEvent',
				start: start_date,
				end: end_date,
				user: user,
				types: types
			}
			AppConnector.request(params).then(function(events){
				thisInstance.getCalendarView().fullCalendar('addEventSource', events.result);
				progressInstance.hide();
			});
		}else{
			thisInstance.getCalendarView().fullCalendar('removeEvents');
			progressInstance.hide();
		}
	},
	updateEvent: function (event, delta, revertFunc) {
		console.log(event.end.format());
		console.log(event.start.format());
		var progressInstance = jQuery.progressIndicator();
		var params = {
			module: 'OSSTimeControl',
			action: 'Calendar',
			mode: 'updateEvent',
			id: event.id,
			start: event.start.format(),
			end: event.end.format()
		}
		AppConnector.request(params).then(function (response) {
			if (!response['result']) {
				Vtiger_Helper_Js.showPnotify(app.vtranslate('JS_NO_EDIT_PERMISSION'));
				revertFunc();
			}
			progressInstance.hide();
		},
		function(error){
			progressInstance.hide();
			Vtiger_Helper_Js.showPnotify(app.vtranslate('JS_NO_EDIT_PERMISSION'));
			revertFunc();
		});
	},
	selectDays: function (start, end) {
		var thisInstance = this;
		this.getCalendarCreateView().then(function (data) {
			if (data.length <= 0) {
				return;
			}
			var dateFormat = data.find('[name="date_start"]').data('dateFormat');
			var startDateInstance = Date.parse(start);
			var startDateString = app.getDateInVtigerFormat(dateFormat, startDateInstance);
			var startTimeString = startDateInstance.toString('hh:mm tt');
			var endDateInstance = Date.parse(end);
			var endDateString = app.getDateInVtigerFormat(dateFormat, endDateInstance);
			var endTimeString = endDateInstance.toString('hh:mm tt');

			data.find('[name="date_start"]').val(startDateString);
			data.find('[name="due_date"]').val(endDateString);
			data.find('[name="time_start"]').val(startTimeString);
			data.find('[name="time_end"]').val(endTimeString);

			var headerInstance = new Vtiger_Header_Js();
			headerInstance.handleQuickCreateData(data, {callbackFunction: function (data) {
				thisInstance.addCalendarEvent(data.result);
			}});
			jQuery('.modal-body').css({'max-height': '500px', 'overflow-y': 'auto'});
		});
	},
	addCalendarEvent : function(calendarDetails) {
		var isAllowed = this.isAllowedToAddTimeControl();
		if(isAllowed == false) return;
		var calendarColor = '';
		if(calendarDetails.timecontrol_type.value == 'PLL_BREAK_TIME')
			calendarColor = 'calendarColor_break_time';
		else if(calendarDetails.timecontrol_type.value == 'PLL_HOLIDAY')
			calendarColor = 'calendarColor_holiday';

		var eventObject = {};
		eventObject.id = calendarDetails._recordId;
		eventObject.title = calendarDetails.name.display_value;
		var startDate = Date.parse(calendarDetails.date_start.display_value+'T'+calendarDetails.time_start.display_value);
		eventObject.start = startDate.toString();
		var endDate = Date.parse(calendarDetails.due_date.display_value+'T'+calendarDetails.time_end.display_value);
		var assignedUserId = calendarDetails.assigned_user_id.value;
		eventObject.end = endDate.toString();
		eventObject.url = 'index.php?module=OSSTimeControl&view=Detail&record='+calendarDetails._recordId;
		eventObject.className = 'userColor_'+calendarDetails.assigned_user_id.value+' '+calendarColor;
		this.getCalendarView().fullCalendar('renderEvent',eventObject);
	},
	isAllowedToAddTimeControl : function () {
		if(jQuery('#menubar_quickCreate_OSSTimeControl').length > 0) {
			return true;
		} else {
			return false;
		}
	},
	getCalendarCreateView : function() {
		var thisInstance = this;
		var aDeferred = jQuery.Deferred();

		if(this.calendarCreateView !== false) {
			aDeferred.resolve(this.calendarCreateView.clone(true,true));
			return aDeferred.promise();
		}
		var progressInstance = jQuery.progressIndicator();
		this.loadCalendarCreateView().then(
			function(data){
				progressInstance.hide();
				thisInstance.calendarCreateView = data;
				aDeferred.resolve(data.clone(true,true));
			},
			function(){
				progressInstance.hide();
			}
		);
		return aDeferred.promise();
	},

	loadCalendarCreateView : function() {
		var aDeferred  = jQuery.Deferred();
		var quickCreateCalendarElement = jQuery('#quickCreateModules').find('[data-name="OSSTimeControl"]');
		var url = quickCreateCalendarElement.data('url');
		var name = quickCreateCalendarElement.data('name');
		var headerInstance = new Vtiger_Header_Js();
		headerInstance.getQuickCreateForm(url,name).then(
			function(data){
				aDeferred.resolve(jQuery(data));
			},
			function(){
				aDeferred.reject();
			}
		);
		return aDeferred.promise();
	},
	getCalendarView : function(){
		if(this.calendarView == false) {
			this.calendarView = jQuery('#calendarview');
		}
		return this.calendarView;
	},
	registerChangeView : function(){
		var thisInstance = this;
		$("#calendarview button.fc-button").click(function () {
			thisInstance.loadCalendarData();
		});
	},
	registerEvents : function() {
		this.registerCalendar();
		this.loadCalendarData(true);
		this.registerChangeView();
	}
});