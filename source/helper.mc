using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.Application;

using Toybox.Time;
using Toybox.Time.Gregorian;

class helper {

	var debug,debugDate;
	var fontSmall,fontMedium,font;
	var selectedFont; 
	
	function initialize(){
		font = WatchUi.loadResource(Rez.Fonts.fntHuge); 
		loadFont();
	}
	
	function loadFont(){
		if(selectedFont != Application.getApp().getProperty("Font")){
			selectedFont = Application.getApp().getProperty("Font");
			switch(selectedFont){
				case 1:
					fontMedium = WatchUi.loadResource(Rez.Fonts.fntMedium);
					fontSmall = WatchUi.loadResource(Rez.Fonts.fntSmall);
					break;
				case 2:
					fontMedium = WatchUi.loadResource(Rez.Fonts.mediumJannScript);  // 36px
        			fontSmall = WatchUi.loadResource(Rez.Fonts.smallJannScript);  // 26px
					break;
				case 3:
					fontMedium = WatchUi.loadResource(Rez.Fonts.mediumStiffBrush); // 35px
        			fontSmall = WatchUi.loadResource(Rez.Fonts.smallStiffBrush); // 26px
					break;
				case 4:
					fontMedium = WatchUi.loadResource(Rez.Fonts.mediumKeyVirtue); // 35px
        			fontSmall = WatchUi.loadResource(Rez.Fonts.smallKeyVirtue); // 26px
        			break;
			}
    	}
	}
	
    function getSmallFont(){
    	loadFont();
    	return fontSmall;
	}
	
	function getHours() {
		var hours = System.getClockTime().hour;
		var clockMode = System.getDeviceSettings().is24Hour;
		if(!clockMode && hours >12){
			hours = hours-12;
		}
		return hours.format("%02d").toCharArray();
	}
	
	function showDays(){
		return Application.getApp().getProperty("ShowDays");
	}
	
	function showMonthYear(){
		return Application.getApp().getProperty("ShowMonthYear");
	}
	
	function showBottomLeft(){
		return Application.getApp().getProperty("ShowBottomLeft");
	}
	
	function whatToShowAtBottomLeft(){
		return Application.getApp().getProperty("WhatToShowAtBottomLeft");
	}
	
	function whatToShowAtBottomLeft2(){
		return Application.getApp().getProperty("WhatToShowAtBottomLeft2");
	}
	
	function whatToShowAtBottomLeft3(){
		return Application.getApp().getProperty("WhatToShowAtBottomLeft3");
	}
	
	function getMonthName(number){
		
		switch(number){
			case 1: return "Jan";
			case 2: return "Feb";
			case 3: return "Mar";
			case 4: return "Apr";
			case 5: return "May";
			case 6: return "Jun";
			case 7: return "Jul";
			case 8: return "Aug";
			case 9: return "Sep";
			case 10: return "Oct";
			case 11: return "Nov";
			case 12: return "Dec";			
		}
	}
	
	function getWeekdayName(number){
		
		switch(number){
			case 1: return "Sun";
			case 2: return "Mon";
			case 3: return "Tue";
			case 4: return "Wed";
			case 5: return "Thu";
			case 6: return "Fri";
			case 7: return "Sat";			
		}
	}
	
	function drawWeekDay2(dc,x,y,offset){
		var time = null;
		if(offset==0){
			time = Time.now();
		}else if (offset<0){
			time = Time.now().subtract(new Time.Duration(3600 *24 * (-offset)));
		}else if (offset>0){
			time = Time.now().add(new Time.Duration(3600 *24 * offset));
		}       	
    	var day = Gregorian.info(time, Time.FORMAT_SHORT);    	

    	dc.drawText(x,y, getSmallFont(), Lang.format(
	    	"$1$ $2$",
		    	[
			        getWeekdayName(day.day_of_week),
			        day.day.format("%02d")
			        
			    ]
			), Graphics.TEXT_JUSTIFY_LEFT);
	}
	
	function setColors(dc){
		var bgColor = Application.getApp().getProperty("BackgroundColor");
        var fgColor = Application.getApp().getProperty("ForegroundColor");
        dc.setColor(Graphics.COLOR_TRANSPARENT, bgColor);
    	dc.clear();
    	dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);
	}
	
	function getSteps(){
		if(debug){
			return "99999stps";
		}
		return Lang.format("$1$$2$",[ActivityMonitor.getInfo().steps,"stps"]);
	}
	function getCalories(){
		if(debug){
			return "99999cal";
		}
		return Lang.format("$1$$2$",[ActivityMonitor.getInfo().calories,"cal"]);
	}
	function getMsgs(force){
		if(debug){
			return "99msgs";
		}
		var ntfCount = System.getDeviceSettings().notificationCount;
		if(ntfCount>0 || force){
			return Lang.format("$1$$2$",[ntfCount, "msgs"]);
		}
		return "";
	}
	
	function getBattery(){
		if(debug){
			return "100%";
		}
		return Lang.format("$1$$2$",[System.getSystemStats().battery.format("%d")+"%", ""]);
	}
	
	function getHR(){
		var hr = Activity.getActivityInfo().currentHeartRate;
		if(hr!=null){
			return Lang.format("$1$$2$",[hr, "bps"]);
		}
		return "--bps";
	}
	
	function drawTop(dc,x,y){
		drawTopFA(dc,x,y,getSmallFont(),Graphics.TEXT_JUSTIFY_CENTER);
	}
	
	function drawTopLeft(dc,x,y){
		drawTopFA(dc,x,y,getSmallFont(),Graphics.TEXT_JUSTIFY_LEFT);
	}	        
	
	function drawTopFA(dc,x,y,font,align){
		if(showMonthYear()){
			var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
			var label = Lang.format("$1$ $2$",[getMonthName(date.month),date.year]);
        	dc.drawText(x,y, font, label, align);
        	
        	if(debugDate){
        	var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        		for(var t=1;t<=12;t++){dc.drawText(x,y,font, Lang.format("$1$ $2$",[getMonthName(t),date.year]), align);}
        	}
        }
	}
	
	function drawHours(dc,hourX,hourY,adjX,adjY){
		var hours = getHours();
        dc.drawText(hourX,hourY,font,hours[0],Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(hourX+adjX,hourY+adjY,font,hours[1],Graphics.TEXT_JUSTIFY_CENTER);
        if(debug){
	        for(var t=0;t<=2;t++){dc.drawText(hourX,hourY, font, t, Graphics.TEXT_JUSTIFY_CENTER);}
	    	for(var t=0;t<=9;t++){dc.drawText(hourX+adjX,hourY+adjY, font, t, Graphics.TEXT_JUSTIFY_CENTER);}
		}
	}
	
	function drawMinutes(dc,minuteX,minuteY,adjX,adjY){
    	var minutes = System.getClockTime().min.format("%02d").toCharArray();
    	dc.drawText(minuteX,minuteY,font,minutes[0],Graphics.TEXT_JUSTIFY_CENTER);
    	dc.drawText(minuteX+adjX,minuteY+adjY,font,minutes[1],Graphics.TEXT_JUSTIFY_CENTER);
    	if(debug){
	    	for(var t=0;t<=5;t++){dc.drawText(minuteX,minuteY, font, t, Graphics.TEXT_JUSTIFY_CENTER);}
	    	for(var t=0;t<=9;t++){dc.drawText(minuteX+adjX,minuteY+adjY, font, t, Graphics.TEXT_JUSTIFY_CENTER);}
		}
	}
	
	function drawTopRight(dc,x,y,stepY,daysForward){
		if(showDays()){
      		for(var day=0;day<daysForward;day++){
	        	drawWeekDay2(dc,x,y+(stepY*day),day);
	        }
        }
	}
	
	function drawLineByOption(dc,x,y,option){
		switch(option){
	    	case 1: 
	    		dc.drawText(x,y, getSmallFont(),getSteps(),Graphics.TEXT_JUSTIFY_RIGHT);
	    		break;
	    	case 2: 
	    		dc.drawText(x,y, getSmallFont(),getCalories(),Graphics.TEXT_JUSTIFY_RIGHT);
	    		break;
			case 3: 
	    		dc.drawText(x,y, getSmallFont(),getMsgs(true),Graphics.TEXT_JUSTIFY_RIGHT);
	    		break;
			case 4: 
	    		dc.drawText(x,y, getSmallFont(),getBattery(),Graphics.TEXT_JUSTIFY_RIGHT);
	    		break;
    		case 5: 
	    		dc.drawText(x,y, getSmallFont(),getHR(),Graphics.TEXT_JUSTIFY_RIGHT);
	    		break;
    		case 6: 
	    		break;
	    }
	}
	
	function drawBottomLeft(dc,x,y,stepY){
		if(showBottomLeft()){
	        drawLineByOption(dc,x,y,whatToShowAtBottomLeft());
	        drawLineByOption(dc,x,y+stepY,whatToShowAtBottomLeft2());
	        drawLineByOption(dc,x,y+stepY+stepY,whatToShowAtBottomLeft3());        	
        }
	}
		
	function ifScreen(screenWidth,screenHeight,screenShape){
		return 
			screenWidth == System.getDeviceSettings().screenWidth &&
			screenHeight == System.getDeviceSettings().screenHeight &&	
			screenShape == System.getDeviceSettings().screenShape;
	}

}
