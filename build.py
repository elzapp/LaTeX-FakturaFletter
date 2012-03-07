import yaml
import subprocess
import codecs
import csv
import os
import datetime

data=yaml.load(open("data.yaml"))
config=data["config"]
orgname=config["orgname"]
address=r"""\\""".join(config["address"])
orgnr=config["orgnr"].replace(" ",r"""\,""")
kontonr=config["kontonr"].replace(" ",r"""\,""")
head=r"""\HeadMatter{\begin{tabular}{c}%s\\%s\\{\small Organisasjonsnr: %s}\end{tabular}}""" % (orgname,address,orgnr)
head +="\n"+r"""\MyAddress{%s\\%s}""" % (orgname,address)
head +="\n"+r"""\MyTown{%s}""" % (config["city"],)
head +="\n"+r"""\MyAccount{%s}""" % (kontonr,)

with open("latex/config.tex","w") as out:
	out.write(head)

fakturanr=config["counter"]

csvfile=codecs.open("medlemmer.txt",encoding="UTF-8")
fakturaer=[]

invoicedate=(datetime.datetime.today()+datetime.timedelta(days=1)).strftime("%d.%m.%Y")
lastdate=(datetime.datetime.today()+datetime.timedelta(days=30)).strftime("%d.%m.%Y")

for csvline in csvfile:
	payer=[e.strip() for e in csvline.split(",")]
	if csvline.find("#obsolete")>0:
		continue
	fakturanr+=1
	navn=payer[0]
	email=payer[1]
	adresse=payer[2]
	poststed=payer[3]
	fakturanrf="2012-%04d" % (fakturanr)
	(varelinje,total)=config["typer"][payer[4]]
	formattedprice=("% 8.2f" % total)
	medlemsnr=payer[5]
	fakturaer.append(fakturanrf)
	with codecs.open("latex/faktura%s.tex" % fakturanrf, "w", encoding="UTF-8") as out:
		sum=0.0
		out.write(r"""\documentclass{no.oao.girofaktura}"""+"\n")
		out.write(r"""\begin{document}"""+"\n")
		out.write(r"""\input{config.tex}"""+"\n")
		out.write(r"""\ToCompany{%s\\%s\\%s}""" % (navn,adresse,poststed)+"\n")
		out.write(r"""\CustNo{%s}""" % (medlemsnr,)+"\n")
		out.write(r"""\YourRef{}"""+"\n")
		out.write(r"""\InvoiceNo{%s}""" % (fakturanr,)+"\n")
		out.write(r"""\InvoiceDate{%s}""" % (invoicedate,)+"\n")
		out.write(r"""\LastDate{%s}""" % (lastdate,)+"\n")
		out.write(r"""\SumTot{%d}{00}""" % (total)+"\n")
		out.write(r"""\InvoiceTop"""+"\n")
		out.write(r"""\begin{Articles}"""+"\n")

		out.write(r"""\Article{%s}{%s}""" %(varelinje,formattedprice)+"\n")
		out.write(r"""\Divider"""+"\n")
		out.write(r"""\Sum"""+"\n")
		out.write(r"""\end{Articles}"""+"\n")
		out.write(r"""\InvoiceBottom"""+"\n")
		out.write(r"""\end{document}""")

os.chdir("latex")
for faktura in fakturaer:
	tex="faktura%s.tex" % (faktura,)
	subprocess.call(["latex",tex])
	subprocess.call(["pdflatex",tex])
os.chdir("..")
try:
	os.makedirs("PDF")
except OSError,e:
	pass
for faktura in fakturaer:
	pdf="faktura%s.pdf" % (faktura,)
	log="faktura%s.log" % (faktura,)
	aux="faktura%s.aux" % (faktura,)
	dvi="faktura%s.dvi" % (faktura,)
	tex="faktura%s.tex" % (faktura,)
	os.rename("latex/"+pdf,"PDF/"+pdf)
	os.remove("latex/"+log)
	os.remove("latex/"+aux)
	os.remove("latex/"+dvi)
	os.remove("latex/"+tex)