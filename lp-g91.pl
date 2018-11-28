/*------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------- Projeto de Logica ------------------------------------------------------*/
/*------------------------------------------------------ para Programacao ------------------------------------------------------*/
/*------------------------------------------ Pedro Caldeira 83539, Joao Pina 85080 ---------------------------------------------*/
/*----------------------------------------------------------Grupo 91------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------*/

movs_possiveis(Lab, Pos_atual, Movs, Poss):- identifica_celula(Pos_atual, Lab, 1, Celula),
					     subtract([c,b,e,d], Celula, Pos_possiveis),
					     procura_para_modificar(Pos_possiveis, Pos_atual, Poss_i),
    					     seleciona_movs(Movs,Poss_i,Poss).

    					    		
distancia((L1, C1),(L2, C2),Dist):- Dist is abs(L1 - L2) + abs(C1 - C2).


ordena_poss(Poss, Poss_ord, Pos_inicial, Pos_final):- insertion(Poss, Poss_ord_1, Pos_inicial, Pos_final),
                                                      insertion2(Poss_ord_1, Poss_ord, Pos_inicial, Pos_final).

resolve1(Lab, (X,Y), Pos_final, Movs):- resolve1(Lab, Pos_final, (X,Y), Movs, [(i,X,Y)]).

resolve2(Lab, Pos_inicial, Pos_final, Movs):- Pos_inicial = (X,Y),
                                              resolve2(Lab, Pos_inicial, Pos_final, (X,Y), Movs, [(i,X,Y)]).

/*------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------Predicados auxiliares---------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------------------------------*/


/*--------------------------------------------------Auxiliares da movspossiveis-------------------------------------------------*/


/*i_esimo(abcissa ou ordenada, lista, contador, lista de saida)*/
/*funcao que procura a lista com as barreiras da posicao atual*/

i_esimo(P, [H|_], P, H).
i_esimo(P, [_|L], Contador, Nova_lista):- P \= Contador,
                                          Contador_novo is Contador + 1,
                                          i_esimo(P, L, Contador_novo, Nova_lista).
	
/*procura_para_modificar(lista, coordenada, lista de movimentos possiveis)*/
/*funcao que altera as coordenadas das posicoes de modo a obter a possibilidade*/ 

procura_para_modificar(Pos_possiveis, Pos_atual, Poss_i):- procura_para_modificar(Pos_possiveis, Pos_atual, Poss_i, []).
procura_para_modificar([], _, X, X).
procura_para_modificar([P|R], Pos_atual, Lista_possibilidades, Ac):- altera_coordenadas(P, Pos_atual, Possibilidade),
	                                                             append(Ac, [Possibilidade], T),
	                                                             procura_para_modificar(R, Pos_atual,Lista_possibilidades, T).



/*altera_coordenadas(letra, coordenada, coordenada nova)*/
/*funcoes que calculam as novas coordenadas para onde o movimento e possivel*/

altera_coordenadas(c, (P1, P2), (X,Y,Z)):- P1_novo is P1-1,
	                                       (X,Y,Z) = (c, P1_novo, P2).

altera_coordenadas(b, (P1, P2), (X,Y,Z)):- P1_novo is P1+1,
	                                       (X,Y,Z) = (b, P1_novo, P2).

altera_coordenadas(e, (P1, P2), (X,Y,Z)):- P2_novo is P2-1,
	                                       (X,Y,Z) = (e, P1, P2_novo).

altera_coordenadas(d, (P1, P2), (X,Y,Z)):- P2_novo is P2+1,
	                                       (X,Y,Z) = (d, P1, P2_novo).



	
/*identifica_celula((X,Y), lista, contador, saida)*/
/*funcao que procura uma determinada coordenada*/

identifica_celula((X,Y), Lista, Contador, Saida):- i_esimo(X, Lista, Contador, Nova_lista),
                                                   i_esimo(Y, Nova_lista, Contador, Saida).

/*seleciona_movs(lista que queremos comparar, lista da qual queremos remover elementos, Saida)*/
/*Subtrai a lista de possibilidades a lista das celulas por onde a resolucao do labirinto ja passou*/

seleciona_movs([], Poss_i, Poss_i).
seleciona_movs([(_,X,Y)|R], Poss_i, Poss):- seleciona_poss_i((X,Y), Poss_i,Poss_i, Poss_i_novo),
                                            seleciona_movs(R, Poss_i_novo, Poss).
seleciona_poss_i(_, [], Poss_i_novo,Poss_i_novo):- !.
seleciona_poss_i((X,Y), [(E,X,Y)|_], Poss_i,Poss_i_novo):- !, 
                                                           subtract(Poss_i, [(E,X,Y)], Poss_i_novo).
seleciona_poss_i((X,Y), [_|Q], Poss_i, Poss_i_novo):- seleciona_poss_i((X,Y), Q, Poss_i, Poss_i_novo).




/*--------------------------------------------------Auxiliares da ordena_poss-----------------------------------------------------*/


/*calcula_distancia(Possibilidade, Posicao,Dist)*/
/*calcula a distancia entre uma possibilidade e uma posicao*/

calcula_distancia((_,X,Y),(Q,V),Dist):- distancia((X,Y),(Q,V),Dist).



/*insertion( Lista de movimentos, Saida) */
/*ordena os membros de uma lista em relacao a posicao final*/

insertion(List,Sorted, Pos_inicial, Pos_final):- i_sort(List,[],Sorted,Pos_inicial, Pos_final).



/*i_sort(Lista,acumulador,saida,pos_inicial,pos_final*/
/*Serve de auxiliar para a insertion*/

i_sort([],Acc,Acc, _, _).
i_sort([H|T],Acc,Sorted, Pos_inicial, Pos_final):- insert(H,Acc,NAcc, Pos_inicial, Pos_final),
                                                   i_sort(T,NAcc,Sorted, Pos_inicial, Pos_final).
insert(X,[],[X], _, _).                      
insert(X,[Y|T],[Y|NT], _, Pos_final):- calcula_distancia(X, Pos_final, Saida1),
                                       calcula_distancia(Y, Pos_final, Saida2),
                                       Saida1>=Saida2,
                                       insert(X,T,NT, _, Pos_final).
                         
insert(X,[Y|T],[X,Y|T], _, Pos_final):- calcula_distancia(X, Pos_final, Saida1),
                                        calcula_distancia(Y, Pos_final, Saida2),
                                        Saida1<Saida2.



/*insertion( Lista de movimentos, Saida) */
/*ordena os membros de uma lista em relacao a posicao inicial*/
                          
insertion2(List,Sorted, Pos_inicial, Pos_final):- i_sort2(List,[],Sorted, Pos_inicial, Pos_final).


i_sort2([],Acc,Acc, _, _).
i_sort2([H|T],Acc,Sorted, Pos_inicial, Pos_final):- insert2(H,Acc,NAcc, Pos_inicial, Pos_final),
                                                    i_sort2(T,NAcc,Sorted, Pos_inicial, Pos_final).

insert2(X,[],[X], _, _).  
                    
insert2(X,[Y|T],[Y|NT], Pos_inicial, _):- calcula_distancia(X, Pos_inicial, Saida1),
                                          calcula_distancia(Y, Pos_inicial, Saida2),
                                          Saida1=<Saida2,
                                          insert2(X,T,NT, Pos_inicial, _).
                         
insert2(X,[Y|T],[X,Y|T], Pos_inicial, _):- calcula_distancia(X, Pos_inicial, Saida1),
                                           calcula_distancia(Y, Pos_inicial, Saida2),
                                           Saida1>Saida2.
                          

/*--------------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------resolve1-------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------*/

/*resolve1(Lab,Pos_inicial,Pos_final,Saida)*/
/*Devolve a solucao do labirinto com as possibilidades na ordem de c,b,e,d*/


resolve1(_, Pos_final, Pos_final, Acumulador, Acumulador):- !.

/*No maximo existem 4 movimentos possiveis na posicao inicial e para as restantes posicoes*/
/*Logo colocamos os quatro casos possiveis para o caso de o primeiro caminho falhar*/
resolve1(Lab, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                        i_esimo(_, Poss, 1, Out),
                                                        retira_coordenada([Out], Coord),
                                                        append(Acumulador, [Out], Movs_novo),
                                                        resolve1(Lab, Pos_final, Coord, Movs, Movs_novo).

resolve1(Lab, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                        i_esimo(2, Poss, 1, Out),
                                                        retira_coordenada([Out], Coord),
                                                        append(Acumulador, [Out], Movs_novo),
                                                        resolve1(Lab, Pos_final, Coord, Movs, Movs_novo).

resolve1(Lab, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                        i_esimo(3, Poss, 1, Out),
                                                        retira_coordenada([Out], Coord),
                                                        append(Acumulador, [Out], Movs_novo),
                                                        resolve1(Lab, Pos_final, Coord, Movs, Movs_novo).
                                                        
resolve1(Lab, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                        i_esimo(4, Poss, 1, Out),
                                                        retira_coordenada([Out], Coord),
                                                        append(Acumulador, [Out],Movs_novo),
                                                        resolve1(Lab, Pos_final, Coord, Movs, Movs_novo).


/*retira_coordenada(lista_poss,saida)*/
/*consegue o X e o Y de uma possibilidade*/                                                                                                                
retira_coordenada([(_, X, Y) | _], (X,Y)).



/*--------------------------------------------------------------------------------------------------------------------------------*/
/*-----------------------------------------------------resolve2-------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------*/


/*resolve2(Lab,Pos_inicial,Pos_final,Saida)*/
/*Devolve a solucao do labirinto com as possibilidades na ordem de distancias relativas a pos_inicial e pos_final*/


resolve2(_, _, Pos_final, Pos_final, Acumulador, Acumulador):- !.

/*No maximo existem 4 movimentos possiveis na posicao inicial e para as restantes posicoes*/
/*Logo colocamos os quatro casos possiveis para o caso de o primeiro caminho falhar*/

resolve2(Lab, Pos_inicial, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                                     ordena_poss(Poss, Poss_ord, Pos_inicial, Pos_final),
                                                                     i_esimo(1, Poss_ord, 1, Out),
                                                                     retira_coordenada([Out], Coord),
                                                                     append(Acumulador, [Out], Movs_novo),
                                                                     resolve2(Lab, Pos_inicial, Pos_final, Coord, Movs, Movs_novo).

resolve2(Lab, Pos_inicial, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                                     ordena_poss(Poss, Poss_ord, Pos_inicial, Pos_final),
                                                                     i_esimo(2, Poss_ord, 1, Out),
                                                                     retira_coordenada([Out], Coord),
                                                                     append(Acumulador, [Out], Movs_novo),
                                                                     resolve2(Lab, Pos_inicial, Pos_final, Coord, Movs, Movs_novo).

resolve2(Lab, Pos_inicial, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                                     ordena_poss(Poss, Poss_ord, Pos_inicial, Pos_final),
                                                                     i_esimo(3, Poss_ord, 1, Out),
                                                                     retira_coordenada([Out], Coord),
                                                                     append(Acumulador, [Out], Movs_novo),
                                                                     resolve2(Lab, Pos_inicial, Pos_final, Coord, Movs, Movs_novo).
                                                        
resolve2(Lab, Pos_inicial, Pos_final, Pos_atual, Movs, Acumulador):- movs_possiveis(Lab, Pos_atual, Acumulador, Poss),
                                                                     ordena_poss(Poss, Poss_ord, Pos_inicial, Pos_final),
                                                                     i_esimo(4, Poss_ord, 1, Out),
                                                                     retira_coordenada([Out], Coord),
                                                                     append(Acumulador, [Out],Movs_novo),
                                                                     resolve2(Lab, Pos_inicial, Pos_final, Coord, Movs, Movs_novo).


