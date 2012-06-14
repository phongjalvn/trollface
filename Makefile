watch:
	@FACEBOOK_APP_ID='242635384971'
	@FACEBOOK_APP_SECR='2236411e218eadfe32f59c621125a560'
	@nodemon -x coffee app.coffee
	# @nodemon node app.js

build:
	@coffee -o ./ app.coffee

deploy:
	@coffee -o ./ app.coffee
	@jitsu deploy

.PHONY: watch
