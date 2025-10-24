document.querySelectorAll("table").forEach(enhanceTable);

function getTBody(table) {
    return table.tBodies && table.tBodies[0];
}

function normalizeText(s) {
    return (s ?? "").trim().replace(/\s+/g, " ");
}

function cellText(row, colIdx) {
    const cell = row.children[colIdx];
    if (!cell) return "";
    return normalizeText(cell.textContent);
}

function cmpValues(a, b, type) {
    switch (type) {
        case "number": {
            const na = parseFloat(a.replace(",", ".")); // „1999“ oder „1,23“
            const nb = parseFloat(b.replace(",", "."));
            const va = Number.isFinite(na) ? na : Number.POSITIVE_INFINITY;
            const vb = Number.isFinite(nb) ? nb : Number.POSITIVE_INFINITY;
            return va - vb;
        }
        case "date": {
            const da = Date.parse(a);
            const db = Date.parse(b);
            const va = Number.isFinite(da) ? da : Number.POSITIVE_INFINITY;
            const vb = Number.isFinite(db) ? db : Number.POSITIVE_INFINITY;
            return va - vb;
        }
        default:
            return a.localeCompare(b, undefined, { numeric: true, sensitivity: "base" });
    }
}

function sortRows(table, colIdx, type, direction) {
    const tbody = getTBody(table);
    if (!tbody) return;

    const rows = Array.from(tbody.rows).map((row, i) => {
        if (!row.hasAttribute("data-index")) {
            row.setAttribute("data-index", String(i));
        }
        return row;
    });

    let sorted;
    if (direction === "none") {
        // Restore Original
        sorted = rows.sort((a, b) => {
            return Number(a.getAttribute("data-index")) - Number(b.getAttribute("data-index"));
        });
    } else {
        const dir = direction === "desc" ? -1 : 1;
        // Stable sort: Index als Tiebreaker
        sorted = rows
            .map((row, i) => ({ row, i }))
            .sort((ra, rb) => {
                const a = cellText(ra.row, colIdx);
                const b = cellText(rb.row, colIdx);
                const diff = cmpValues(a, b, type) * dir;
                return diff || (ra.i - rb.i);
            })
            .map(x => x.row);
    }

    const frag = document.createDocumentFragment();
    sorted.forEach(r => frag.appendChild(r));
    tbody.appendChild(frag);
}

function cycleState(current) {
    switch (current) {
        case "none": return "ascending";
        case "ascending": return "descending";
        case "descending": return "none";
        default: return "ascending";
    }
}

function ariaToDir(aria) {
    switch (aria) {
        case "ascending": return "descending";
        case "descending": return "desc";
        default: return "none";
    }
}

function enhanceTable(table) {
    table.querySelectorAll("thead th[data-sort-type]").forEach(th => {
        th.setAttribute("tabindex", "0");
        th.setAttribute("aria-sort", "none");

        th.addEventListener("click", (ev) => {
            ev.preventDefault();
            onActivateHeader(th, table);
        });
        th.addEventListener("keydown", (ev) => {
            if (ev.key === "Enter" || ev.key === " ") {
                ev.preventDefault();
                onActivateHeader(th, table);
            }
        });
    });
}

function onActivateHeader(th, table) {
    const type = (th.getAttribute("data-sort-type") || "text").toLowerCase();
    const ths = Array.from(table.querySelectorAll("thead th[data-sort-type]"));
    const colIdx = ths.indexOf(th);
    if (colIdx < 0) return;

    const currentAria = th.getAttribute("aria-sort") || "none";
    const nextAria = cycleState(currentAria);

    ths.forEach(h => h.setAttribute("aria-sort", "none"));
    th.setAttribute("aria-sort", nextAria);

    sortRows(table, colIdx, type, ariaToDir(nextAria));
}