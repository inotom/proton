module ApplicationHelper

  # return complete page title
  def full_title(page_title = '')
    base_title = "Proton"
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def work_status_class(status)
    if status
      "done"
    else
      "progress"
    end
  end

  def work_status_string(status)
    if status
      "o"
    else
      "-"
    end
  end

  def worktime_fmt(time, fmt = I18n.t('view.worktime_format'))
    time.strftime(fmt) unless time.nil?
  end

  def total_worktimes_fmt(total)
    hours = total.divmod(60 * 60)
    mins  = hours[1].divmod(60)
    "#{I18n.t("view.worktimes_total_hour", count: hours[0])} #{I18n.t("view.worktimes_total_minute", count: mins[0])}"
  end
end
