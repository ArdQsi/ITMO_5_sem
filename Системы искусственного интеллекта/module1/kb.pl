%facts

%игроки
player(ard).
player(upuzipu).
player(shipim).
player(denis).
player(sashok).

%оружия
weapon(ak47).
weapon(awp).
weapon(p90).
weapon(aug).
weapon(famas).
weapon('ssg 08').
weapon(nova).
weapon('desert eagle').

%карты
map(dust2).
map(inferno).
map(mirage).
map(ancient).

%команды
team(counter_terrorist).
team(terrorist).

%классификация оружия
classification(rifles).
classification(mid-tier).
classification(pistols).

%predicates

%любимая карта у каждого игрока
favorite_map(ard, dust2).
favorite_map(upuzipu, ancient).
favorite_map(denis, inferno).
favorite_map(shipim, mirage).
favorite_map(sashok, dust2).

%любимое оружие у игрока
favorite_weapon(ard, awp).
favorite_weapon(denis, p90).
favorite_weapon(upuzipu, ak47).
favorite_weapon(shipim, aug).
favorite_weapon(sashok, nova).

%какую команду выбрал игрок
player_team(ard, terrorist).
player_team(shipim, terrorist).
player_team(denis, counter-terrorist).
player_team(upuzipu, counter-terrorist).
player_team(sashok, terrorist).

%киллы у каждого игрока
player_kills(shipim, 10).
player_kills(ard, 25).
player_kills(denis, 12).
player_kills(upuzipu, 5).
player_kills(sashok, 24).

%здоровье у каждого игрока
player_health(denis, 100).
player_health(shipim, 80).
player_health(ard, 65).
player_health(sashok, 78).
player_health(upuzipu, 54).

%стоимость оружия
weapon_cost(ak47, 2700).
weapon_cost(p90, 2350).
weapon_cost(awp, 4750).
weapon_cost(aug, 3300).
weapon_cost(famas, 2050).
weapon_cost(nova, 1050).
weapon_cost('ssg 08', 1700).
weapon_cost('desert eagle', 700).

%классификация оружия
classification_of_weapon(ak47, rifles).
classification_of_weapon(p90, mid-tier).
classification_of_weapon(nova, mid-tier).
classification_of_weapon(awp, rifles).
classification_of_weapon(aug, rifles).
classification_of_weapon(famas, rifles).
classification_of_weapon('ssg 08', rifles).
classification_of_weapon('desert eagle', pistols).

%какие оружия есть в каждой команде
weapon_belongs(ak47, terrorist).
weapon_belongs(p90, terrorist).
weapon_belongs(p90, counter-terrorist).
weapon_belongs(nova, terrorist).
weapon_belongs(nova, counter-terrorist).
weapon_belongs(awp, terrorist).
weapon_belongs(awp, counter-terrorist).
weapon_belongs(aug, counter-terrorist).
weapon_belongs(famas, counter-terrorist).
weapon_belongs('ssg 08', terrorist).
weapon_belongs('ssg 08', counter-terrorist).
weapon_belongs('desert eagle', terrorist).
weapon_belongs('desert eagle', counter-terrorist).

%rules

%показать какие оружия можно купить игроку на определенную сумму
buy_weapon(Player, Weapon, Cost) :- player_team(Player, Team), weapon_belongs(Weapon, Team), weapon_cost(Weapon, X) , Cost >= X.

%является ли оружие снайперкой
sniper(Weapon) :- weapon(Weapon), (Weapon = awp ; Weapon = ssg).

%убьет ли один игрока другого
kill(Player1, Player2) :- player_health(Player1, X), player_health(Player2, Y), X > Y.

%найденная карта понравится ли игроку
searching_map_is_favorite(Name, Nickname) :- map(Name), favorite_map(Nickname, Name).

%достаточно ли денег на покупку любимого оружия
having_money_for_favorite_weapon(Nickname, Money) :- favorite_weapon(Nickname, Weapon), weapon_cost(Weapon, Cost), Money >= Cost.

%поиск максимального количества убийств среди игроков
maximum_number_of_kills(Kills) :- findall(Y, player_kills(_, Y), List), max_list(List, Kills).

%queries

%kill(denis, shipim).
%favorite_map(Name, dust2).
%sniper(awp).
%searching_map_is_favorite(dust2, X).
%having_money_for_favorite_weapon(ard, 3400).
%maximum_number_of_kills(Kills).