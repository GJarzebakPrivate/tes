IN THE SOURCE FOLDER : docker build -t my-django-app . 
IN THE TERRAFORM FOLDER : TERRAFORM PLAN && TERRAFORM APPLY 

this will build the image and push it to ecr 

it's pushed using provisioner (would do with githubactions but am on holiday until 24th)

give it some time app will be available under url displayed by the output i defined 

