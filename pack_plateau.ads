with pack_piece,pack_joueur,pack_file_gen;
use pack_piece,pack_joueur;

package pack_plateau is

   type Tplateau is array (1..8,1..8) of t_piece;


   procedure initPlateau(jeu: in out Tplateau);
   Procedure afficherPlateau(jeu:in Tplateau);
   procedure remplirePlateau(jeu:in out tplateau;jou:in t_joueur);
   Procedure AjoutePieceSurPlateau( piece :in out t_piece; mycase : Tcase; Plateau : in out Tplateau) ;
   Function getListeDeplacementsPossibles( jeu : in Tplateau; Piece :t_piece ) return  file_gen_TfileCases.tfile;
   procedure mini_dep(madir :in file_gen_deplacement.tfile; file:in out file_gen_TfileCases.tfile;file_A_attacker:in out file_gen_TfileCases.tfile;jeu:in Tplateau;piece:in t_piece);
   function return_piece(p:in Tplateau;x,y:in Integer) return t_piece;
   procedure maj_joueur(joueur:in out t_joueur;jeu:in Tplateau);
   function "=" (p:in tcase;p2:in tcase) return Boolean;
   procedure brain(joueur:in out t_joueur;joueur_advrs:in t_joueur; jeu: in out Tplateau);
   procedure joueur_manuellement(joueur_manu: in out t_joueur; Plateau:in out Tplateau);
end pack_plateau;
