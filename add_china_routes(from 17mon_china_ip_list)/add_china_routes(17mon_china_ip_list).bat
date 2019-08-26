echo create china_routes hash:net family inet hashsize 2048 maxelem 9999 >> ipset-save-china-router.list

for /F %%i in (.\china_ip_list.txt) do (

echo %%i
echo add china_routes %%i >> ipset-save-china-router.list
)
