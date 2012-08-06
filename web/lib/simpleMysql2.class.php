<?php

/*
simpleMySql class.
by Marc

A tiny PHP / MySQL class.

connect($host, $database, $username, $password)
	Connexion � la base de donn�e
	Connect to database

close()
	Fermeture de la connexion
	Close connection

exec($req)
	Ex�cution d'une requ�te, sauf type SELECT
	Execute request, except SELECT
	
select($req)
	Ex�cute une requ�te de type SELECT
	Execute a SELECT request
	
getNbRows()
	Retourne le nombre de lignes de r�sultat (disponible apr�s une requ�te SELECT)
	Get results' count (only after a SELECT statement)
	
Toutes les fonction suivantes doivent suivre un appel � select()
All following functions must be executed after a select()
fetchCell()
	Retourne une valeur unique (dans le cas d'une requ�te rapatriant 1 ligne et 1 colonne)
	Get a single cell result (must be a 1 line 1 column request)
	
fetchLineObject()
	Retourne une ligne de r�sultat sous la forme d'un objet (Resultat d'une ligne). On utilisera la valeur retourn�e ainsi : $lineObj->VAR
	Get a line of result as an object. Use $lineObj->VAR_NAME to obtain the value.
	
fetchLineArray()
	Retourne une ligne de r�sultat sous la forme d'un tableau � une dimension. $lineArray[COL_INDEX]
	Get a line of result as a single dimension array. $lineArray[COL_INDEX]
	
fetchColArray()
	Retourne plusieurs lignes de r�sultats limit�s � une colonne sous la forme d'un tableau � une dimension $colArray[LINE_INDEX]
	Get several result lines of one column as a single dimension array. $colArray[LINE_INDEX]
	
fetchKeyValueArray()
	Retourne plusieurs lignes de r�sultats de deux colonnes sous la forme d'un tableau � deux dimensions $colsArray[LINE_INDEX][COL_INDEX]
	Get several result lines of two columns as a double dimension array. $colsArray[LINE_INDEX][COL_INDEX]
	
fetchKeyValueAssoc()
	Retourne plusieurs lignes de r�sultats de deux colonnes sous la forme d'un tableau associatif.
	La premi�re colonne servira de cl� pour acc�der � la valeur de la seconde $hash["COL1_VAL"] -> COL2_VAL
	Get several result lines of two columns as an associative array. 
	First column of the request is the key, second column is the value. $hash["COL1_VAL"] -> COL2_VAL

fetchLinesArray()
	Retourne plusieurs lignes de r�sultats sous la forme d'un tableau � deux dimensions. $tab[LINE_INDEX][COL_INDEX]
	Get several result lines as a double dimension array. $tab[LINE_INDEX][COL_INDEX]
	
fetchLinesObjects()
	Retourne plusieurs lignes de r�sultats sous la forme d'un tableau d'objets. $tab[LINE_INDEX]->VAR_NAME
	Get several result lines as an objects array. $tab[LINE_INDEX]->VAR_NAME
	
fetchLinesAssoc()
	Retourne plusieurs lignes de r�sultats sous la forme d'un tableau associatif. $tab[LINE_INDEX]["VAR_NAME"]
	Get several result lines as an associative array. $tab[LINE_INDEX]["VAR_NAME"]
	
Toutes les fonctions suivante ex�cute la requ�te SELECT pass�e en param�tre, puis retourne le r�sultat. Se r�ferer aux fonctions fetch*.
All following functions executes the $req parameter as a SELECT, then return the result directly. Refer to fetch* functions.
selectCell($req)
selectLineObject($req)
selectLineArray($req)
selectColArray($req)
selectKeyValueArray($req)
selectKeyValueAssoc($req)
selectLinesArray($req)
selectLinesObjects($req)
selectLinesAssoc($req)

getGrammar($singular, $plural, $none)
	Retourne $singular, $plural ou $none, en fonction du nombre de r�sultats du SELECT pr�cedent. Utile pour afficher un nombre de r�sultat dans la page.
	Remplace <NUM> par le nombre de ligne dans le cas ou $plural est retourn�.
	> getGrammar("Il y a un r�sultat", "Il y a <NUM> r�sultats", "Pas de r�sultat")
	> #Si une ligne de r�sulat, retourne "Il y a un r�sultat", si 42 lignes "Il y a 42 r�sultats", si aucun "Pas de r�sultat"
	Returns $singular, $plural ou $none, according to the last SELECT result counts. Could be used to prompt a result summary.
	> getGrammar("One result", "There's <NUM> results", "No result")
	> #If 1 line of result, return "One result", if 42 lines "There's 42 results", if none "No result"
	
	
setDebug($debug)
	Modifie l'affichage du mode debug. (true / false)
	Modify debug mode state.
	
printDebug($req)
	Affiche les informations sur la derni�re erreur.
	Prompt last error text.
*/


class simpleMysql
{
	var $_dbCnx;
	var $_results;
	var $_cur;
	var $_nbRows = 0;
	var $_error;
	var $_debug = false;
	
	#
	# connect
	#
	function connect($host, $database, $username, $password)
	{
		if (!$this->_dbCnx = mysql_connect($host,$username,$password))
		{
			print "CEST MORT!!!";
			return -1;
		}
		if (!mysql_select_db($database, $this->_dbCnx))
		{
			$this->_error = mysql_error();
			return -1;
		}
		return 0;
	}

	#
	# close connection
	#
	function close()
	{
		mysql_close();
	}
	
	#
	# exec
	#
	function exec($req)
	{
		if ($this->_results = mysql_query($req))
		{
			return mysql_affected_rows();
		}
		else
		{
			if ($this->_debug)
			{
				$this->printDebug($req);
			}
			return -1;
		}
	}
	
	#
	# select
	#
	function select($req)
	{
		if ($this->_debug == 2)
		{
			$this->printDebug($req);
		}
		if (!$this->_results = mysql_query($req))
		{
			if ($this->_debug)
			{
				$this->printDebug($req);
			}
			return -1;
		}
		$this->_nbRows = mysql_num_rows($this->_results);
		return $this->_nbRows;
	}
	
	#
	# getNbRows
	#
	function getNbRows()
	{
		return $this->_nbRows;
	}

	#
	# fetchCell
	# 
	function fetchCell()
	{
		if ($line = mysql_fetch_row($this->_results))
		{
			return $line[0];
		}
		else
		{
			return null;
		}
	}
	
	#
	# fetchLineObject
	# 
	function fetchLineObject()
	{
		if($cur = mysql_fetch_object($this->_results))
		{
			return $cur;
		}
		else
		{
			return null;
		}
	}

	#
	# fetchLineArray
	#
	function fetchLineArray()
	{
		$tab = Array();
		if($tab = mysql_fetch_row($this->_results))
		{
			return $tab;
		}
		else
		{
			return null;
		}
	}
	
	#
	# fetchColArray
	#
	function fetchColArray()
	{
		$tab = Array();
		if ($this->getNbRows())
		{
			while ($line = mysql_fetch_row($this->_results))
			{
				$tab[] = $line[0];
			}
			return $tab;
		}
		else
		{
			return null;
		}
	}
	
	#
	# fetchKeyValueArray
	#
	function fetchKeyValueArray()
	{
		$tab = Array();
		if ($this->getNbRows())
		{
			while ($line = mysql_fetch_row($this->_results))
			{
				$tab[] = Array($line[0], $line[1]);
			}
			return $tab;
		}
		else
		{
			return null;
		}
	}
		
	#
	# fetchKeyValueAssoc
	#
	function fetchKeyValueAssoc()
	{
		$tab = Array();
		if ($this->getNbRows())
		{
			while ($line = mysql_fetch_row($this->_results))
			{
				$tab[$line[0]] = $line[1];
			}
			return $tab;
		}
		else
		{
			return null;
		}
	}
	
	#
	# fetchLinesArray
	#
	function fetchLinesArray()
	{
		$tab = Array();
		if ($this->getNbRows())
		{
			while ($line = mysql_fetch_array($this->_results))
			{
				$tab[] = $line;
			}
			return $tab;
		}
		else
		{
			return null;
		}
	}
	
	#
	# fetchLinesObjects
	#
	function fetchLinesObjects()
	{
		$tab = Array();
		if ($this->getNbRows())
		{
			while ($cur = mysql_fetch_object($this->_results))
			{
				$tab[] = $cur;
			}
			return $tab;
		}
		else
		{
			return null;
		}
	}
	
	#
	# fetchLinesAssoc
	#
	function fetchLinesAssoc()
	{
		$tab = Array();
		if ($this->getNbRows())
		{
			while ($line = mysql_fetch_assoc($this->_results))
			{
				$tab[] = $line;
			}
			return $tab;
		}
		else
		{
			return null;
		}
	}
	
	#
	# selectCell
	#
	function selectCell($req)
	{
		$this->select($req);
		return $this->fetchCell();
	}
	
	#
	# selectLineObject
	#
	function selectLineObject($req)
	{
		$this->select($req);
		return $this->fetchLineObject();
	}

	#
	# selectLineArray
	#
	function selectLineArray($req)
	{
		$this->select($req);
		return $this->fetchLineArray();
	}
	
	#
	# selectColArray
	#
	function selectColArray($req)
	{
		$this->select($req);
		return $this->fetchColArray();
	}
	
	#
	# selectKeyValueArray
	#
	function selectKeyValueArray($req)
	{
		$this->select($req);
		return $this->fetchKeyValueArray();
	}
		
	#
	# selectKeyValueAssoc
	#
	function selectKeyValueAssoc($req)
	{
		$this->select($req);
		return $this->fetchKeyValueAssoc();
	}
	
	#
	# selectLinesArray
	#
	function selectLinesArray($req)
	{
		$this->select($req);
		return $this->fetchLinesArray();
	}

	#
	# selectLinesObjects
	#
	function selectLinesObjects($req)
	{
		$this->select($req);
		return $this->fetchLinesObjects();
	}
	
	#
	# selectLinesAssoc
	#
	function selectLinesAssoc($req)
	{
		$this->select($req);
		return $this->fetchLinesAssoc();
	}
	
	#
	# getGrammar
	#
	function getGrammar($singular, $plural, $none)
	{
		$nbRows = $this->getNbRows();
		if ($nbRows > 1)
		{
			$plural = str_replace("<NUM>", $nbRows, $plural);
			return $plural;
		}
		else if ($nbRows == 1)
		{
			return $singular;
		}
		else
		{
			return $none;
		}
	}
	
	#
	# setDebug
	#
	function setDebug($debug)
	{
        	$this->_debug = $debug;
	}
    
	#
	# printDebug
	#
	function printDebug($req)
	{
		if ($this->_debug == 2)
		{
			print "<BR />Request \"".$req."\"<BR />";
		}
		else if ($debug == 1)
		{
			print "<BR />[".mysql_errno()."] ".mysql_error()."<BR />Request was \"".$req."\"<BR />";
		}
	}
	
}
?>