@echo off
set CP=./system/felix-launcher.jar;./system/org.apache.felix.framework-5.6.10.jar

setlocal enabledelayedexpansion
for %%f in (ext\*) do ( 
	@set "CP=!CP!;%%f"
)

set VM_ARGS=-Dfile.encoding=UTF-8 -Dogema.resources.useByteCodeGeneration=true -Dorg.osgi.framework.storage.fromlevel=40 -Dorg.ogema.persistence=active -Dfelix.config.properties=file:./config/config.properties
set SECURITY_ARGS=-Dorg.osgi.framework.security=osgi -Djava.security.policy=config/all.policy
set CLEAN_ARGS=-Dorg.osgi.framework.storage.clean=onFirstInit

:TOP
IF $%1$ == $$ GOTO RUN
IF %1 == -security (
set VM_ARGS=%VM_ARGS% %SECURITY_ARGS%
SHIFT
GOTO TOP
)
IF %1 == -clean (
set VM_ARGS=%VM_ARGS% %CLEAN_ARGS%
SHIFT
GOTO TOP
)

:RUN
set MAIN_CLASS=org.apache.felix.main.Main

set JAVA=java

REM find out java version; in case of java >= 9 add required modules
REM see https://stackoverflow.com/questions/17714681/get-java-version-from-batch-file
for /f tokens^=2-5^ delims^=.+-_^" %%j in ('%JAVA% -fullversion 2^>^&1') do @set "jver=%%j%%k%%l%%m"

if %jver:~0,1%==1 (
	@set "jver=%jver:~1,1%"
) else (
	@set "jver=%jver:~0,1%"
)
REM workaround for java version 10,11.
if %jver% LEQ 2  @set "jver=1%jver%"
REM https://issues.apache.org/jira/browse/FELIX-5727
if %jver% GEQ 9 @set "JAVA=%JAVA% --add-modules java.xml.bind --add-opens=java.base/jdk.internal.loader=ALL-UNNAMED"

@echo on
%JAVA% %VM_ARGS% -cp %CP% %MAIN_CLASS%
@echo off
endlocal