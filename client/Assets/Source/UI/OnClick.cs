﻿using UnityEngine;
    {
        on_click
    }
        {
            Button btn = GetComponent<Button>();
            btn.onClick.AddListener(() => Do());
        }