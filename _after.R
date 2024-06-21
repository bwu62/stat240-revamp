# copy demo.html if inexistent or changed
if(
  file.exists("demo.html") && (
    !file.exists("docs/demo.html") || 
    tools::md5sum("demo.html") != 
    tools::md5sum("docs/demo.html")
  )
) file.copy("demo.html","docs/",overwrite=T)
