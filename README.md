# Camp reservations

Rails aplikace na rezervace pobytů v kempu s omezenou kapacitou (počet lidí).

## Téma

Kempová místa. **Camp** má `capacity` — kolik lidí může v kempu přespat najednou. **Reservation** je skupina (`name`, `amount` lidí) od `start_date` do `end_date`.

## Setup

Ruby 3.2.4, Rails 7.2, MySQL.

```bash
bundle install
bin/rails db:setup
bin/rails server
```

`db:setup` vytvoří databázi, nahraje schema a vzorová data.

Otevřít http://localhost:3000

Přihlašovací údaje k MySQL jsou v `config/database.yml` (`root` / `root`, socket `/tmp/mysql.sock`).

## Jak vyzkoušet kapacitu

Seednutý **Pine Ridge** má kapacitu 10. Překrývající se rodiny už na některých nocích zabírají 9 míst.

1. Otevřít Pine Ridge.
2. Přidat rezervaci na 2 osoby přes ty překrývající se dny (od dneška na několik dní dopředu).
3. Uložení se musí zamítnout.
4. Stejná rezervace na 1 osobu projde.

**Lakeside** je plný (4/4) ve dvou navazujících pobytech, které se potkají jen v den odjezdu. Třetí skupina na stejné noci se musí zamítnout; pobyt začínající v den odjezdu projde. V kalendáři kempu jsou ty noci označené jako full.

## DECISIONS

- **Dva modely:** `Camp has_many :reservations`. Kapacita patří kempu; rezervace drží jen kdo přijíždí, kolik lidí a termín. User model není — zadání auth nepožaduje.
- **`amount` místo počítání řádků:** rodina o 4 lidech zabere 4 z kapacity kempu. Příklad ze zadání („bazén rezervovaný max. 10 osobami“) je o lidech, ne o počtu záznamů.
- **Půlotevřený interval `[start_date, end_date)`:** den odjezdu místo nezabírá. Tak to v kempech funguje a dvě skupiny se můžou vystřídat v jeden den, aniž by se „srazily“.
- **Autorita je validace na rezervaci:** `Reservation#fits_camp_capacity` běží při create i update. Frontend ani kalendář rezervaci neuloží — `save` to stejně zastaví.
- **Kalendář jen zobrazuje:** na camp show se z `occupancy_timeline` vezme `full` a vykreslí měsíční mřížka. Neukládá data, jen ukazuje, které dny už kapacitu drží.
- **Nested routes:** new/create rezervace visí na kempu; show/edit/update/destroy jsou top-level. Seznam rezervací kempu je na camp `show`, navíc je i globální reservation index.

## Proč kontrola kapacity funguje

Každá rezervace se změní na dvě události: `+amount` v `start_date` a `-amount` v `end_date`. Po seřazení podle data (odjezdy před příjezdy ve stejný den) je běžící součet obsazenost v každém okamžiku změny. Pokud nikdy nepřekročí `capacity`, žádný okamžik není přeplněný. Pouhé počítání překrývajících se řádků by nestačilo: dva pobyty, které se navzájem nepřekrývají, můžou oba překrývat třetí — aniž by kdy byly tři najednou.

## Co bych udělal s více času

Zamknout řádek kempu (nebo exclusion constraint), aby dva souběžné requesty neprošly kontrolou oba. Jedna sweep-line metoda pro validaci i kalendář, ať se algoritmus neduplikuje. Validace `end_date > start_date` a zákaz snížit kapacitu kempu pod aktuální obsazenost. Request testy na controllery.

## Testy

```bash
bin/rails test
```
