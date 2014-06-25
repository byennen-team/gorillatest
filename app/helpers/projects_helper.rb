module ProjectsHelper

  def script_email_content(project)
    newline = "%0A"
    subject = "subject=Please add this JS Snippet so I can start GorillaTesting!"
    body = "body=Hello my smart friend -- I would like to start using GorillaTest to turn my testing frown upside down, and in order to do so I need you to insert the code below into the HEAD of the site to be tested. If you have any questions feel free to check out the documentation at https://www.gorillatest.com/documentation or email support@gorillatest.com."
    script = "<script src='#{ENV['API_URL']}/assets/recordv2.js' data-api-key='#{project.api_key}' data-project-id='#{project.id.to_s}'></script>"

    return "#{subject}#{newline}&#{body}#{newline}#{newline}CODE:#{newline}#{script}"
  end

  def link_to_record(project)
    if project.url.match(/\?\w*/)
      return project.url + "&gt-recording=true"
    else
      return project.url + "?gt-recording=true"
    end
  end
end
