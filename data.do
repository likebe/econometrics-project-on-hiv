*do file for final project 

destring(GDPpercapita), replace force
destring(GDPpercapitalastyear), replace force
destring(Foreigndirectinvestment), replace force
destring(Inflationconsumerprices), replace force
gen inflation = Inflationconsumerprices/100

*replace missing value with the mean 
gen FDI_miss = Foreigndirectinvestment == .
sum Foreigndirectinvestment
replace Foreigndirectinvestment = r(mean) if FDI_miss == 1

gen GDPPC_miss = GDPpercapita == .
sum GDPpercapita
replace GDPpercapita = r(mean) if GDPPC_miss == 1

gen ICP_miss = inflation == .
sum inflation
replace inflation = r(mean) if ICP_miss == 1

gen GDPPCLY_miss = GDPpercapitalastyear == .
sum GDPpercapitalastyear
replace GDPpercapitalastyear = r(mean) if GDPPCLY_miss == 1

*change GDPPC to log 
gen logGDPPC = ln(GDPpercapita)
gen logGDPPCLY = ln(GDPpercapitalastyear)


reg  HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration GDPPCLY_miss, robust
	outreg2 using data.xls, dec(3) replace 
	
reg  HIVtotal logGDPPC logGDPPCLY Healthexpenditure Secondaryeducationduration Genderratio Unemployment GDPPCLY_miss GDPPCLY_miss, robust
	outreg2 using data.xls, dec(3) 
	
	
reg  HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration Genderratio Unemployment  inflation  Foreigndirectinvestment GDPPC_miss FDI_miss ICP_miss, robust
	outreg2 using data.xls, dec(3) 
	
	
gen unemployementXsecondary = Unemployment * Secondaryeducationduration
gen genderRatioXsecondary = Genderratio * Secondaryeducationduration
gen inflationXforeign = inflation * Foreigndirectinvestment


reg  HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration Genderratio Unemployment inflation Foreigndirectinvestment unemployementXsecondary genderRatioXsecondary GDPPC_miss ICP_miss, robust
	outreg2 using data.xls, dec(3) 
	
*LAD
qreg HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration Genderratio Unemployment inflation Foreigndirectinvestment unemployementXsecondary genderRatioXsecondary GDPPC_miss ICP_miss, vce(robust) 
	outreg2 using data.xls, dec(3) ctitle(LAD) 
	
*Country Fixed Effect

encode CountryName, generate (countryid)

xtset countryid
xtreg  HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration Genderratio Unemployment  inflation  Foreigndirectinvestment unemployementXsecondary genderRatioXsecondary GDPPC_miss FDI_miss ICP_miss, fe r
	outreg2 using data.xls, dec(3) 

*Time Fixed Effect

xtset Time
	
xtreg  HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration Genderratio Unemployment  inflation  Foreigndirectinvestment GDPPC_miss FDI_miss ICP_miss unemployementXsecondary genderRatioXsecondary, fe r
	outreg2 using data.xls, dec(3) 

	
*Both Fixed Effects
xtset countryid 
xtreg HIVtotal logGDPPC Healthexpenditure Secondaryeducationduration Genderratio Unemployment  inflation unemployementXsecondary genderRatioXsecondary Foreigndirectinvestment GDPPC_miss FDI_miss ICP_miss i.Time ,fe r
	outreg2 using data.xls, dec(3) 
	


