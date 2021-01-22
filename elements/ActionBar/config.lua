ActionBarBindMap = {
    ['1'] = '1',
    ['2'] = '2',
    ['3'] = '3',
    ['4'] = '4',
    ['F'] = 'F',
    ['SF'] = 'SHIFT-F',
    ['R'] = 'R',
    ['SB5'] = 'SHIFT-BUTTON5',
    ['SB4'] = 'SHIFT-BUTTON4',
    ['S1'] = 'SHIFT-1',
    ['S2'] = 'SHIFT-2',
    ['S3'] = 'SHIFT-3',
    ['S4'] = 'SHIFT-4',
    ['E'] = 'E',
    ['SE'] = 'SHIFT-E',
    ['SR'] = 'SHIFT-R',
    ['Q'] = 'Q',
    ['SQ'] = 'SHIFT-Q',
    ['B5'] = 'BUTTON5',
    ['B4'] = 'BUTTON4',
    ['CQ'] = 'CTRL-Q',
    ['CM5'] = 'CTRL-BUTTON5',
    ['A1'] = 'ALT-1',
    ['A2'] = 'ALT-2',
    ['A3'] = 'ALT-3',
    ['A4'] = 'ALT-4',
    ['AF'] = 'ALT-F',
    ['AE'] = 'ALT-E',
    ['AR'] = 'ALT-R',
    ['AQ'] = 'ALT-Q',
    ['AM5'] = 'ALT-BUTTON5',
    ['AM4'] = 'ALT-BUTTON4',
}

d3ui_ActionBarTabs = 12

d3ui_ActionBarEmptyButton = { hidden = true, tabs = {} }

d3ui_ActionBarEmptyBar = {
    length = 10,
    buttons = {
        [1] = { tabs = {}},
        [2] = { tabs = {}},
        [3] = { tabs = {}},
        [4] = { tabs = {}},
        [5] = { tabs = {}},
        [6] = { tabs = {}},
        [7] = { tabs = {}},
        [8] = { tabs = {}},
        [9] = { tabs = {}},
        [10] = { tabs = {}},
        [11] = { tabs = {}},
        [12] = { tabs = {}},
    },
    DISPLAY = {
        ORIENTATION = 'HORIZONTAL',
        SIZE = 24,
        SPACE = 4,
        POINT = 'RIGHT',
        X = 0,
        Y = 0
    }
}
-- declare default bars and button states
d3ui_ActionBarDefaultConf = {
    [1] = {
        length = 9,
        buttons = {
            [1] = { bind = '1', tabs = {}},
            [2] = { bind = '2', tabs = {}},
            [3] = { bind = '3', tabs = {}},
            [4] = { bind = '4', tabs = {}},
            [5] = { bind = 'F', tabs = {}},
            [6] = { bind = 'SF', tabs = {}},
            [7] = { bind = 'R', tabs = {}},
            [8] = { bind = 'SB5', tabs = {}},
            [9] = { bind = 'SB4', tabs = {}},
        },
        DISPLAY = {
            SIZE = 32,
            SPACE = 4,
            POINT = 'BOTTOM',
            X = 0,
            Y = 330
        }
    },
    [2] = {
        length = 11,
        buttons = {
            [1] = { bind = 'S1', tabs = {}},
            [2] = { bind = 'S2', tabs = {}},
            [3] = { bind = 'S3', tabs = {}},
            [4] = { bind = 'S4', tabs = {}},
            [5] = { bind = 'E', tabs = {}},
            [6] = { bind = 'SE', tabs = {}},
            [7] = { bind = 'SR', tabs = {}},
            [8] = { bind = 'Q', tabs = {}},
            [9] = { bind = 'SQ', tabs = {}},
            [10] = { bind = 'B5', tabs = {}},
            [11] = { bind = 'B4', tabs = {}},
        },
        DISPLAY = {
            SIZE = 24,
            SPACE = 4,
            POINT = 'BOTTOM',
            MODEST = false,
            X = 0,
            Y = 300
        }
    },
    [3]  = {
        length = 12,
        buttons = {
            [1] = { bind = 'CQ', tabs = {}},
            [2] = { bind='CM5', tabs = {}},
            [3] = { tabs = {}},
            [4] = { tabs = {}},
            [5] = { tabs = {}},
            [6] = { tabs = {}},
            [7] = { tabs = {}},
            [8] = { tabs = {}},
            [9] = { tabs = {}},
            [10] = { tabs = {}},
            [11] = { tabs = {}},
            [12] = { tabs = {}},
        },
        DISPLAY = {
            ORIENTATION = 'HORIZONTAL',
            SIZE = 24,
            SPACE = 4,
            POINT = 'RIGHT',
            X = -4,
            Y = 192
        },
    },
    [4]  = {
        length = 12,
        buttons = {
            [1] = { tabs = {}},
            [2] = { tabs = {}},
            [3] = { tabs = {}},
            [4] = { tabs = {}},
            [5] = { tabs = {}},
            [6] = { tabs = {}},
            [7] = { tabs = {}},
            [8] = { tabs = {}},
            [9] = { tabs = {}},
            [10] = { tabs = {}},
            [11] = { tabs = {}},
            [12] = { tabs = {}},
        },
        DISPLAY = {
            ORIENTATION = 'HORIZONTAL',
            SIZE = 24,
            SPACE = 4,
            POINT = 'RIGHT',
            X = -4,
            Y = -174
        }
    },
    [5]  = {
        length = 4,
        buttons = {
            [1] = { tabs = {}},
            [2] = { tabs = {}},
            [3] = { tabs = {}},
            [4] = { tabs = {}},
        },
        DISPLAY = {
            ORIENTATION = 'VERTICAL',
            SIZE = 24,
            SPACE = 4,
            MODEST = true,
            POINT = 'TOP',
            X = 0,
            Y = 0
        }
    },
    [6]  = {
        length = 10,
        buttons = {
            [1] = { bind='A1', tabs = {}},
            [2] = { bind='A2', tabs = {}},
            [3] = { bind='A3', tabs = {}},
            [4] = { bind='A4', tabs = {}},
            [5] = {bind='AF', tabs = {}},
            [6] = { bind='AE', tabs = {}},
            [7] = { bind='AR', tabs = {}},
            [8] = { bind='AQ', tabs = {}},
            [9] = { bind='AM5',tabs = {}},
            [10] = {bind='AM4', tabs = {}},
        },
        DISPLAY = {
            ORIENTATION = 'VERTICAL',
            SIZE = 24,
            SPACE = 4,
            MODEST = false,
            POINT = 'BOTTOM',
            X = 0,
            Y = 270
        }
    }
}