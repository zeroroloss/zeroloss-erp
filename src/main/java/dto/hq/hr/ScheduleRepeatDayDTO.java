package dto.hq.hr;

public class ScheduleRepeatDayDTO {
	private Integer scheduleId;
	private Integer weekdayRepeat;

	public ScheduleRepeatDayDTO() {
		super();
	}

	public ScheduleRepeatDayDTO(Integer scheduleId, Integer weekdayRepeat) {
		super();
		this.scheduleId = scheduleId;
		this.weekdayRepeat = weekdayRepeat;
	}

	public Integer getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(Integer scheduleId) {
		this.scheduleId = scheduleId;
	}

	public Integer getWeekdayRepeat() {
		return weekdayRepeat;
	}

	public void setWeekdayRepeat(Integer weekdayRepeat) {
		this.weekdayRepeat = weekdayRepeat;
	}

	@Override
	public String toString() {
		return "ScheduleRepeatDayDTO [scheduleId=" + scheduleId + ", weekdayRepeat=" + weekdayRepeat + "]";
	}
}

