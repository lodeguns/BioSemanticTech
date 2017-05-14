# In the same repository the associated PDF documentation:
# R Technologies and Web Semantic - Bardozzo

#R and Web Semantic - Installation Step

 install.packages("rJava") # if not present already
 
if (Sys.getenv("JAVA_HOME")!="")
  Sys.setenv(JAVA_HOME="")
 
library(rJava) #works

 install.packages("devtools") # if not present already
 
library(devtools)

 install_github("rrdf", "egonw", subdir="rrdflibs") # if not present already
 install_github("rrdf", "egonw", subdir="rrdf", build_vignettes = FALSE) # if not present already

library(rrdf) #works
library(rrdflibs) #works

 
 
 
 
store = new.rdf(ontology=FALSE)

add.triple(store, subject="http://example.org/Subject",
           predicate="http://example.org/Predicate",
           object="http://example.org/Object" )

add.triple(store, subject="http://example2.org/Subject",
            predicate="http://example2.org/Predicate",
            object="http://example.org/Object"  )
 

 add.data.triple(store, subject="http://example.org/Subject",
                 predicate="http://example.org/Predicate",
                 data="Value")
 add.data.triple(store, subject="http://example.org/Subject",
                 predicate="http://example.org/Predicate",
                 data="1", type="integer")
 add.data.triple(store, subject="http://example.org/Subject",
                 predicate="http://example.org/Predicate",
                 data="benzeen", lang="nl")

 save.rdf(store, "store_Ex.xml", "RDF/XML")

 results = construct.rdf(store, paste(
   "CONSTRUCT {?instance a <http://example.org/Object2>}",
   "WHERE { ?instance a <benzeen> }"
 ))
 
 
 store = new.rdf()
 add.triple(store,
            subject="http://example.org/Subject",
            predicate="http://example.org/Predicate",
            object="http://example.org/Object")
 results = construct.rdf(store, paste(
   "CONSTRUCT { ?instance a <http://example.org/AnotherObject> }",
   "WHERE { ?instance a <http://example.org/Object> }"
 ))
 
 #/uniprot_Ex.xml
 
 store = new.rdf()
 store = construct.remote("http://beta.sparql.uniprot.org/sparql/",
"PREFIX up:<http://purl.uniprot.org/core/> 
PREFIX taxon:<http://purl.uniprot.org/taxonomy/> 
PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#> 
CONSTRUCT{?protein a up:Protein . 
 ?protein up:sequence ?aa }
WHERE
{
  ?protein a up:Protein .
	?protein up:organism ?organism . 
	{
		?protein up:organism taxon:83333 .
	} UNION {
		?protein up:organism ?organism .
		?organism rdfs:subClassOf+ taxon:83333 .
	} 
	?protein up:sequence ?s .
	?s rdf:value ?aa
} LIMIT 5")
  
 
 save.rdf(store, "uniprot_Ex.xml", "RDF/XML")

 
 
 
 
 
library(rrdf) #works
library(rrdflibs) #works
library(RCurl)

Dgluc = getURL(
  "https://apps.ideaconsult.net/data/query/compound/search/all?search=glucose", 
  .opts = list(ssl.verifypeer = FALSE),
  write=basicTextGatherer()
) # note: use list(ssl.verifypeer = FALSE,followlocation=TRUE) to see content

 querySparql <- paste(
   "PREFIX ot: <http://www.opentox.org/api/1.1#>",
   "SELECT DISTINCT ?compound WHERE {",
   " ?compound a ot:Compound",
   "}"
 )

storeChemDgluc = fromString.rdf(Dgluc)

compounds = sparql.rdf(storeChemDgluc, querySparql)
 
newstore <- new.rdf()

add.triple( newstore, 
              subject="http://glucose.org/Subject", 
              predicate="http://glucose.org/Predicate", 
              object="http://glucose.org/Object") 

   results = construct.rdf(newstorestore, 
                           paste( "CONSTRUCT { ?instance a <http://example.org/AnotherObject> }", 
                                  "WHERE { ?instance a <http://example.org/Object> }" )
                           ) 
 
 
 
 
 
 
 
 store = new.rdf()
 add.triple(store,
            subject="http://example.org/Subject",
            predicate="http://example.org/Predicate",
            object="http://example.org/Object")

 
 
 
 
 
 
 
 
 
 
 
 
 
                        
 
 
 
 
 
 
 
 
 







library(rrdf)
library(rrdflibs)
 
metnet<-new.rdf(ontology=FALSE)
 
load.rdf("eco00010.rdf", format = "RDF/XML", metnet)

save.rdf(metnet, "eco00010N3.xml", "N3")





