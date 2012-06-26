watch:
	#@FACEBOOK_APP_ID='242635384971'
	@FACEBOOK_APP_ID='252913768155075'
	@FACEBOOK_APP_SECR='76e399664ba9d8256e23548b613bc4f4'
	@nodemon -x coffee app.coffee
	# @nodemon node app.js

build:
	@coffee -o ./ app.coffee

deploy:
	@coffee -o ./ app.coffee
	@jitsu deploy --noanalyze

.PHONY: watch
