# author-diversity


The purpose of this R shiny app is to look at the diversity of authors I have been reading in terms of gender and country of birth as part of #diversifyyorbookshelf.

Created using data scraped from my Goodreads account. 
The starting URL for the web scraper is the read page in the following format: table view, 20 per page, sorted by date. 
On Goodreads, you can log a book as read without a date attached to it or multiple dates. 
If there are multiple authors of a book only the first author was taken as that is what is displayed on the Goodreads page.
The gender and country living in data were manually gathered and added on by googling info on authors or their Goodreads bios. 
The scraped data is supplied in the data folder and is available to reproduce the results. 

The app reacts to the time sliders at the bottom so you can see if patterns change over time. 
As you can enter read books on goodreads without a date there is a check box to add in authors with the date is NA. How this works is that the check box sets the data to have the lower value of the slider date. 
The app will ensure that authors are only counted once within the range of a slider. i.e., if I read a series of books by the dame author they would only be counted once assuming I read one or more of the series in the date sliders range. 


What I learnt from this exercise regarding author diversity is that I mainly read American authors. I will in future be looking to read books by more Asian, European (not including the UK) and South American authors who are drastically lacking from my location diversity.
I am rather happy with the gender split between Male and Female gendered authors however what is desperately lacking is gender diverse authors and I will be looking to read more books written by gender diverse people going forward.




