/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

const CONDITION_ACTIVE_WINDOW_FLAG = 0;
const CONDITION_ACTIVE_WINDOW_STRING = 1;
const CONDITION_ACTIVE_WINDOW_REGEX = 2;

class Condition {
    constructor(effectIndex) {
        this.effectIndex = effectIndex;
    }

    checkCondition(_widget) {
        throw new Error("Not implemented");
    }

    static fromModel(model) {
        switch (model.conditionType) {
            case CONDITION_ACTIVE_WINDOW_FLAG:
                return new ActiveWindowFlagCondition(model.effectIndex, model.arg0, !!model.arg1);
            case CONDITION_ACTIVE_WINDOW_STRING:
                return new ActiveWindowStringCondition(model.effectIndex, model.arg0, model.arg1);
            case CONDITION_ACTIVE_WINDOW_REGEX:
                return new ActiveWindowRegexpCondition(model.effectIndex, model.arg0, model.arg1);
            default:
                throw new Error("Unsupported condition type: " + model.conditionType);
        }
    }
}

class ActiveWindowCondition extends Condition {
    constructor(effectIndex) {
        super(effectIndex);
    }

    checkCondition(widget) {
        return widget.tasksModel.hasActiveWindow && this.checkActiveWindowCondition(widget.tasksModel.activeWindow);
    }

    checkActiveWindowCondition(_activeWindow) {
        throw new Error("Not implemented");
    }
}

class ActiveWindowFlagCondition extends ActiveWindowCondition {
    constructor(effectIndex, propertyName, propertyValue) {
        super(effectIndex);
        this.propertyName = propertyName;
        this.propertyValue = propertyValue;
    }

    checkActiveWindowCondition(activeWindow) {
        return activeWindow[this.propertyName] === this.propertyValue;
    }
}

class ActiveWindowStringCondition extends ActiveWindowCondition {
    constructor(effectIndex, propertyName, propertyValue) {
        super(effectIndex);
        this.propertyName = propertyName;
        this.propertyValue = propertyValue;
    }

    checkActiveWindowCondition(activeWindow) {
        return activeWindow[this.propertyName] === this.propertyValue;
    }
}

class ActiveWindowRegexpCondition extends ActiveWindowCondition {
    constructor(effectIndex, propertyName, regExp) {
        super(effectIndex);
        this.propertyName = propertyName;
        this.regExp = new RegExp(regExp, "g");
    }

    checkActiveWindowCondition(activeWindow) {
        const value = activeWindow[this.propertyName];
        return (value === undefined || value === null) ? false : value.match(this.regExp);
    }
}
