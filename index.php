<?php
    session_start();
    require_once("Donnees.inc.php");
    if (!isset($_SESSION['favori']) && !isset($_GET['favori'])) {
        $_SESSION['favori'] = false;
    }
    elseif (isset($_GET['favori'])) {
        $_SESSION['favori'] = !$_SESSION['favori'];
    }
    else {
        $_SESSION['favori'] = false;
    }

    if (!isset($_GET['p'])) {
        $_GET['p'] = 'accueil';
    }
?>

<!DOCTYPE html>
<html lang="fr">
    <head>
        <title>Cocktails</title>
        <link rel="icon" type="image/x-icon" href="./photos/photosHorsCocktail/favicon.con"/>
        <link rel="stylesheet" href="./style/stylesheet.css" type="text/css" media="screen"/>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="author" content="Legrand Thomas, Nefnaf Nadir, Baranski Alexis"/>
        <meta name="description" content="Cocktails"/>
        <meta name="keywords" content="Cocktails"/>
    </head>
    <body>
        <header>
            <div>
                <?php
                    if ($_GET['p'] == 'accueil') {
                        ?>
                        <a href="./index.php?p=accueil&navigation=navigation">Navigation</a>
                        <a href="./index.php?p=accueil&favori=favori">Recette</a>
                        <?php
                    }
                ?>

            </div>
            <div>
                <?php
                    if ($_GET['p'] == 'accueil') {
                        ?>
                        <form action="#" method="post">
                            <label for="recherche">Recherche&nbsp;:</label>
                            <input type="text" name="recherche" id="recherche" required="required" title="+ (ou rien) pour un aliment souhaité, - pour un aliment non souhaité, &quot; pour un aliment composé de plusieurs mots."/>
                            <input type="submit" name="submit" value=""/>
                        </form>
                        <?php
                    }
                ?>
            </div>
            <div>
                <?php
                    if (isset($SESSION['user']['name'])) {
                        ?>
                        <p><strong><?php echo $SESSION['user']['name'];?></strong></p>
                        <a href="index.php?p=profil">Profil</a>
                        <form action="#" method="post">
                            <input type="submit" name="logout" value="Se déconnecter"/>
                        </form>
                        <?php
                    }
                    else {
                        ?>
                        <form action="#" method="post">
                            <label for="login"></label>
                            <input type="text" name="login" id="login" required="required" title="Seulement des chiffres, minuscules et majuscules non accentués"/>
                            <label for="password"></label>
                            <input type="password" name="password" id="password" required="required"/>
                            <input type="submit" name="login" value="Connexion"/>
                            <input type="submit" name="register" value="S'inscrire"/>
                        </form>
                        <?php
                    }
                ?>
            </div>
        </header>

        <?php
            $file = "./include/".$_GET['p'].".php";
            if (file_exists($file)) {
                include($file);
            }
            else {
                ?>
                <p><strong>Erreur 404&nbsp;:</strong> Fichier introuvable</p>
                <img alt="Téma le fag" src="photos/photosHorsCocktail/error404.png"/>
                <?php
            }
        ?>

    </body>
</html>