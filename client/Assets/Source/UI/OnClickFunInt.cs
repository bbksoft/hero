﻿using UnityEngine;
    public int param;

    // Use this for initialization
    void Start()
    {

        Button btn = GetComponent<Button>();
        btn.onClick.AddListener(() => Do());
    }
    }