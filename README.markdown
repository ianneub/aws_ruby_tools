# AWS Ruby Tools
This project contains a few of my ruby scripts that I use to manipulate my Amazon S3 buckets and other Amazon AWS services.

To use them you will need to set your AWS access identifiers in the include.rb file. Then you will need to tweak the settings at the top of each of the other .rb files to use them.

Then just execute

    ruby /path/to/file.rb

You will need to have rubygems installed as well as the [right_aws](http://rightaws.rubyforge.org/) gem.

**Warning:** *Be careful how you use these tools. You could delete your entire bucket if you are not careful.*