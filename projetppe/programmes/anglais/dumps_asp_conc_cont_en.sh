#!/usr/bin/env bash


fichier_urls=$1 # le fichier d'URL en entrée
lineno=1;
cible="racial discrimination"
while read URL || [[ -n $URL ]];
do
	echo "fichier $lineno est en cours de traitement."
	curl -o ../../aspirations/en-$lineno.html $URL
	lynx -accept_all_cookies -dump $URL > ../../dumps-text/en-$lineno.txt
	grep -E -A3 -B3 "racial discrimination" ../../dumps-text/en-$lineno.txt > ../../contexte/en-$lineno.txt
	
	echo "
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Concordances</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
	</head>
			<body>
				<table class="table">
					<thead>
						<tr>
						<th class=\"has-text-left\">Contexte gauche</th>
						<th>Cible</th>
						<th class=\"has-text-right\">Contexte droit</th>
						</tr>
					</thead>
					<tbody>
	" > ../../concordances/concordance_en-$lineno.html
	lynx -accept_all_cookies -dump $URL | grep -E -o "(\w+|\W+){0,10}$cible(\W+|\w+){0,10}" |sort|uniq | sed -E "s/(.*)($cible)(.*)/<tr><td class="has-text-left">\1<\/td><td class="has-text-centered"><strong>\2<\/strong><\/td><td class="has-text-right">\3<\/td><\/tr>/" >> ../../concordances/concordance_en-$lineno.html
	echo "
	</tbody>
	</table>
	</body>
	</html>
	" >> ../../concordances/concordance_en-$lineno.html
	lineno=$((lineno+1));
done < $fichier_urls
exit