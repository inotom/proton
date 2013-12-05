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
end
