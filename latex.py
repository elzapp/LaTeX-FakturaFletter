
class LatexDocument:
	def __init__(self):
		self.content=[]
	def append(self,element):
		self.content.append(element)
		return element
	def __unicode__(self):
		r=""
		for e in self.content:
			r += unicode(e)+"\n"
		return r
class LatexElement:
	def __init__(self,name,*parameters):
		self.content=[]
		self.name=name
		self.parameters=parameters
	def append(self,child):
		self.content.append(child)
		return child

	def __unicode__(self):
		r="\\"+self.name
		for param in self.parameters:
			r+="{"+unicode(param)+"}"
		return r
class LatexBlock:
	def __init__(self,name,*parameters):
		self.content=[]
		self.name=name
		self.parameters=parameters
	def append(self,child):
		self.content.append(child)
		return child

	def __unicode__(self):
		r="\\begin{"+self.name+"}"
		for param in self.paraleters:
			r+="{%s}" % (param,)
		r+="\n"
		for e in self.content:
			r+=unicode(e)+"\n"
		r+="\\end{"+self.name+"}"
		return r



if __name__ == "__main__":
	t=LatexDocument();
	t.append(LatexElement("documentclass",["no.oao.girofaktura"]))
	doc=t.append(LatexBlock("document"))
	doc.append(LatexElement("input",["config.tex"]))
	doc.append(LatexElement("ToCompany",["Foo Inc\\\\infinite loop"]))
	doc.append(LatexElement("CustNo",[343]))
	doc.append(LatexElement("YourRef",[""]))
	doc.append(LatexElement("InvoiceNo",[4]))
	doc.append(LatexElement("InvoiceDate",["11.03.2012"]))
	doc.append(LatexElement("LastDate",["31.03.2012"]))
	doc.append(LatexElement("SumTot",["500,00"]))
	doc.append(LatexElement("InvoiceTop"))
	art=doc.append(LatexBlock("Articles"))
	art.append(LatexElement("Article",["Bedriftsmedlemskap"," 500,00"]))
	art.append(LatexElement("Divider"))
	art.append(LatexElement("Sum"))
	doc.append("InvoiceBottom")
	print t