how to start
1) add defualt-env.json
2) there are .[file] that aren't copied with git import, add them manually on db folder
3) npm i on root folder (remove job scheduler from package.json for now)
4) run sap db connection on sap hana projects view
5) cds build 
6) "npm i" on /gen/db
7) add "user-provided" on default-env.json from ".env" db source

create new virtual table
1) add new file on sdi/virtualtables
2) configure it
3) deploy it from "sap hana projects" view

create new flowgraph
1) create the new flowgraph 
2) add a new entity on cat-service.cds and data-model.cds
3) cds build
4) cds deploy --to hana
nb: you can also single deploy from "sap hana projects" views

how to deploy
1) edit mta.yaml , comment row 34 and uncomment row 35
2) on terminal -> "mbt build" 
3) then "cf deploy"